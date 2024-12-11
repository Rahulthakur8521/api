import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PostApiProvider with ChangeNotifier {
  List<dynamic> _posts = [];
  List<dynamic> get posts => _posts;

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

      if (response.statusCode == 200) {
        _posts = jsonDecode(response.body);
        notifyListeners();
      } else {
        print("Failed to fetch posts: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while fetching posts: $e");
    }
  }

  Future<Map<String, dynamic>> createPostApi(String title, String body, int userId) async {
    try {
      final requestBody = jsonEncode({
        "title": title,
        "body": body,
        "userId": userId,
      });

      final response = await http.post(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      if (response.statusCode == 201) {
        fetchPosts();
        return {
          'success': true,
          'statusCode': response.statusCode,
        };
      } else {
        print("Failed to create post: ${response.statusCode}");
        return {
          'success': false,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print("Error occurred while creating post: $e");
      return {
        'success': false,
        'statusCode': null,
      };
    }
  }

  Future<Map<String, dynamic>> updatePostApi(int id, String title, String body, int userId) async {
    try {
      final requestBody = jsonEncode({
        "id": id,
        "title": title,
        "body": body,
        "userId": userId,
      });

      final response = await http.put(
        Uri.parse("https://jsonplaceholder.typicode.com/posts/$id"),
        headers: {
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        fetchPosts();
        return {
          'success': true,
          'statusCode': response.statusCode,
        };
      } else {
        print("Failed to update post: ${response.statusCode}");
        return {
          'success': false,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print("Error occurred while updating post: $e");
      return {
        'success': false,
        'statusCode': null,
      };
    }
  }

  Future<bool> deletePostApi(int id) async {
    try {
      final response = await http.delete(Uri.parse("https://jsonplaceholder.typicode.com/posts/$id"));

      if (response.statusCode == 200) {
        fetchPosts();
        return true;
      } else {
        print("Failed to delete post: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error occurred while deleting post: $e");
      return false;
    }
  }
}
