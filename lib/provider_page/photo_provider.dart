import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotoApiProvider with ChangeNotifier {
  List<dynamic> _photos = [];

  List<dynamic> get photos => _photos;

  Future<void> fetchPhotos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (response.statusCode == 200) {
      _photos = json.decode(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<Map<String, dynamic>> createPhotoApi(String title, String url, String thumbnailUrl, int albumId) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/photos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'url': url,
        'thumbnailUrl': thumbnailUrl,
        'albumId': albumId,
      }),
    );

    if (response.statusCode == 201) {
      return {"success": true, "statusCode": response.statusCode};
    } else {
      return {"success": false, "statusCode": response.statusCode};
    }
  }
}
