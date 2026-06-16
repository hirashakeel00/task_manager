import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  Future<List<dynamic>> getPosts() async {
    final response = await dio.get(
      'https://jsonplaceholder.typicode.com/posts',
    );

    return response.data;
  }

  Future<void> updatePost(int id) async {
    try {
      final response = await dio.put(
        'https://jsonplaceholder.typicode.com/posts/$id',
        data: {
          'id': id,
          "title": "updated task",
          "body": "updated body",
          "userId": 1,
        },
      );

      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePost(int it) async {
    try {
      final response = await dio.delete(
        'https://jsonplaceholder.typicode.com/posts/%id',
      );
      print(response.statusCode);
    } catch (e) { 
      print(e);
    }
  }
}
