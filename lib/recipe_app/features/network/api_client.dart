import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  ApiClient(this.dio){
    dio.options = BaseOptions(
      baseUrl: "https://dummyjson.com",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20)
    );
  }
  // Future<Response> get(String path) async {
  //   return await dio.get(path);
  // }
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

}