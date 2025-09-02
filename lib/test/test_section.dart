import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

// Provider for fetching photo data
final photoListProvider = FutureProvider<List<PracticeJson>>((ref) async {
  final url = Uri.parse("https://jsonplaceholder.typicode.com/photos");
  Response response = await get(url, headers: {'Accept': 'application/json'});

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final photoList = data.map((json) => PracticeJson.fromJson(json)).toList();
    debugPrint(photoList.toString());
    return photoList;
  } else {
    throw Exception("Failed to load data: ${response.statusCode}");
  }
});

class TestSection extends ConsumerWidget {
  const TestSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoListAsyncValue = ref.watch(photoListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Test Section",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),

      ),
      body: photoListAsyncValue.when(
        data: (photoList) {
          if (photoList.isEmpty) {
            return const Center(child: Text("No photos found."));
          }
          return ListView.builder(
            itemCount: photoList.length,
            itemBuilder: (context, index) {
              final photo = photoList[index];
              return Card(
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0), // Optional: add some margin
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(photo.thumbnailUrl!),
                    ),
                    title: Text(photo.title!),
                    subtitle: Text(photo.albumId.toString()),
                    trailing: Text(photo.id.toString()),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(child: Text("Error: $error"));
        },
      ),
    );
  }
}
class PracticeJson{
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  PracticeJson({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  PracticeJson.fromJson(Map<String, dynamic> json){
    albumId = json['albumId'];
    id = json['id'];
    title = json['title'];
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
  }

}