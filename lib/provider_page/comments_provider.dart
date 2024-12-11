import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CommentApiProvider with ChangeNotifier {
  List<dynamic> _comments = [];

  List<dynamic> get comments => _comments;

  Future<void> fetchComments() async {
     try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

      if (response.statusCode == 200) {
        _comments = jsonDecode(response.body);
        notifyListeners();
      } else {
        print("Failed to load comments: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while fetching comments: ");
    }
  }

  Future<Map<String, dynamic>> createCommentApi(String name, String email, String body, int postId) async {
    try {
      final requestBody = jsonEncode({
        "name": name,
        "email": email,
        "body": body,
        "postId": postId,
      });

      final response = await http.post(
        Uri.parse("https://jsonplaceholder.typicode.com/comments"),
        headers: {
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      if (response.statusCode == 201) { // 201 Created
        return {
          'success': true,
          'statusCode': response.statusCode,
        };
      } else {
        print("Failed to create comment: ${response.statusCode}");
        return {
          'success': false,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print("Error occurred while creating comment: $e");
      return {
        'success': false,
        'statusCode': null,
      };
    }
  }
}
