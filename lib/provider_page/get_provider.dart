import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/ToDoModel.dart';

class GetProvider with ChangeNotifier {
  List<ToDoModel>? _toDoList;

  List<ToDoModel>? get toDoList => _toDoList;

  Future<void> callToDoApi() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      _toDoList = jsonData.map((data) => ToDoModel.fromJson(data)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load ToDo data');
    }
  }
}