//
// Copyright 2018 gRPC authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifndef GRPC_SRC_CORE_XDS_XDS_CLIENT_XDS_API_H
#define GRPC_SRC_CORE_XDS_XDS_CLIENT_XDS_API_H

#include <stddef.h>

#include <map>
#include <set>
#include <string>
#include <utility>
#include <vector>

#include "absl/status/status.h"
#include "absl/strings/string_view.h"
#include "envoy/admin/v3/config_dump_shared.upb.h"
#include "envoy/service/status/v3/csds.upb.h"
#include "upb/mem/arena.h"
#include "upb/reflection/def.hpp"

#include <grpc/support/port_platform.h>

#include "src/core/lib/debug/trace.h"
#include "src/core/lib/gprpp/ref_counted_ptr.h"
#include "src/core/lib/gprpp/time.h"
#include "src/core/xds/xds_client/xds_bootstrap.h"
#include "src/core/xds/xds_client/xds_client_stats.h"

namespace grpc_core {

class XdsClient;

// TODO(roth): When we have time, split this into multiple pieces:
// - ADS request/response handling
// - LRS request/response handling
// - CSDS response generation
class XdsApi final {
 public:
  // Interface defined by caller and passed to ParseAdsResponse().
  class AdsResponseParserInterface {
   public:
    struct AdsResponseFields {
      std::string type_url;
      std::string version;
      std::string nonce;
      size_t num_resources;
    };

    virtual ~AdsResponseParserInterface() = default;

    // Called when the top-level ADS fields are parsed.
    // If this returns non-OK, parsing will stop, and the individual
    // resources will not be processed.
    virtual absl::Status ProcessAdsResponseFields(AdsResponseFields fields) = 0;

    // Called to parse each individual resource in the ADS response.
    // Note that resource_name is non-empty only when the resource was
    // wrapped in a Resource wrapper proto.
    virtual void ParseResource(upb_Arena* arena, size_t idx,
                               absl::string_view type_url,
                               absl::string_view resource_name,
                               absl::string_view serialized_resource) = 0;

    // Called when a resource is wrapped in a Resource wrapper proto but
    // we fail to parse the Resource wrapper.
    virtual void ResourceWrapperParsingFailed(size_t idx,
                                              absl::string_view message) = 0;
  };

  struct ClusterLoadReport {
    XdsClusterDropStats::Snapshot dropped_requests;
    std::map<RefCountedPtr<XdsLocalityName>, XdsClusterLocalityStats::Snapshot,
             XdsLocalityName::Less>
        locality_stats;
    Duration load_report_interval;
  };
  using ClusterLoadReportMap = std::map<
      std::pair<std::string /*cluster_name*/, std::string /*eds_service_name*/>,
      ClusterLoadReport>;

  // The metadata of the xDS resource; used by the xDS config dump.
  struct ResourceMetadata {
    // Resource status from the ui of a xDS client, which tells the
    // synchronization status between the xDS client and the xDS server.
    enum ClientResourceStatus {
      // Client requested this resource but hasn't received any update from
      // management server. The client will not fail requests, but will queue
      // them
      // until update arrives or the client times out waiting for the resource.
      REQUESTED = 1,
      // This resource has been requested by the client but has either not been
      // delivered by the server or was previously delivered by the server and
      // then subsequently removed from resources provided by the server.
      DOES_NOT_EXIST,
      // Client received this resource and replied with ACK.
      ACKED,
      // Client received this resource and replied with NACK.
      NACKED
    };

    // The client status of this resource.
    ClientResourceStatus client_status = REQUESTED;
    // The serialized bytes of the last successfully updated raw xDS resource.
    std::string serialized_proto;
    // The timestamp when the resource was last successfully updated.
    Timestamp update_time;
    // The last successfully updated version of the resource.
    std::string version;
    // The rejected version string of the last failed update attempt.
    std::string failed_version;
    // Details about the last failed update attempt.
    std::string failed_details;
    // Timestamp of the last failed update attempt.
    Timestamp failed_update_time;
  };
  static_assert(static_cast<ResourceMetadata::ClientResourceStatus>(
                    envoy_admin_v3_REQUESTED) ==
                    ResourceMetadata::ClientResourceStatus::REQUESTED,
                "");
  static_assert(static_cast<ResourceMetadata::ClientResourceStatus>(
                    envoy_admin_v3_DOES_NOT_EXIST) ==
                    ResourceMetadata::ClientResourceStatus::DOES_NOT_EXIST,
                "");
  static_assert(static_cast<ResourceMetadata::ClientResourceStatus>(
                    envoy_admin_v3_ACKED) ==
                    ResourceMetadata::ClientResourceStatus::ACKED,
                "");
  static_assert(static_cast<ResourceMetadata::ClientResourceStatus>(
                    envoy_admin_v3_NACKED) ==
                    ResourceMetadata::ClientResourceStatus::NACKED,
                "");

  XdsApi(XdsClient* client, TraceFlag* tracer, const XdsBootstrap::Node* node,
         upb::DefPool* def_pool, std::string user_agent_name,
         std::string user_agent_version);

  // Creates an ADS request.
  std::string CreateAdsRequest(absl::string_view type_url,
                               absl::string_view version,
                               absl::string_view nonce,
                               const std::vector<std::string>& resource_names,
                               absl::Status status, bool populate_node);

  // Returns non-OK when failing to deserialize response message.
  // Otherwise, all events are reported to the parser.
  absl::Status ParseAdsResponse(absl::string_view encoded_response,
                                AdsResponseParserInterface* parser);

  // Creates an initial LRS request.
  std::string CreateLrsInitialRequest();

  // Creates an LRS request sending a client-side load report.
  std::string CreateLrsRequest(ClusterLoadReportMap cluster_load_report_map);

  // Parses the LRS response and populates send_all_clusters,
  // cluster_names, and load_reporting_interval.
  absl::Status ParseLrsResponse(absl::string_view encoded_response,
                                bool* send_all_clusters,
                                std::set<std::string>* cluster_names,
                                Duration* load_reporting_interval);

  void PopulateNode(envoy_config_core_v3_Node* node_msg, upb_Arena* arena);

 private:
  XdsClient* client_;
  TraceFlag* tracer_;
  const XdsBootstrap::Node* node_;  // Do not own.
  upb::DefPool* def_pool_;          // Do not own.
  const std::string user_agent_name_;
  const std::string user_agent_version_;
};

}  // namespace grpc_core

#endif  // GRPC_SRC_CORE_XDS_XDS_CLIENT_XDS_API_H
