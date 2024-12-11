import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Models/album_model.dart';

class AlbumApiProvider with ChangeNotifier {
  List<Album> _albums = [];

  List<Album> get albums => _albums;

  Future<void> fetchAlbums() async {
    try {
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/albums"));

      if (response.statusCode == 200) {
        Iterable json = jsonDecode(response.body);
        _albums = json.map((album) => Album.fromJson(album)).toList();
        notifyListeners();
      } else {
        print("Failed to fetch albums: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while fetching albums: $e");
    }
  }

  Future<Map<String, dynamic>> createAlbum(String title, int userId) async {
    try {
      final requestBody = jsonEncode({
        "title": title,
        "userId": userId,
      });

      final response = await http.post(
        Uri.parse("https://jsonplaceholder.typicode.com/albums"),
        headers: {
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      if (response.statusCode == 201) { // 201 Created
        fetchAlbums(); // Refresh the list of albums
        return {
          'success': true,
          'statusCode': response.statusCode,
        };
      } else {
        print("Failed to create album: ${response.statusCode}");
        return {
          'success': false,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print("Error occurred while creating album: $e");
      return {
        'success': false,
        'statusCode': null,
      };
    }
  }
}
