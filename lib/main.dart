import 'package:api/provider_page/album_provider.dart';
import 'package:api/provider_page/comments_provider.dart';
import 'package:api/provider_page/get_provider.dart';
import 'package:api/provider_page/photo_provider.dart';
import 'package:api/provider_page/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ScreenPage/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: (context) => GetProvider(),),
        ChangeNotifierProvider(create: (context) => PostApiProvider(),),
        ChangeNotifierProvider(create: (context) => CommentApiProvider(),),
        ChangeNotifierProvider(create: (context) => AlbumApiProvider(),),
        ChangeNotifierProvider(create: (context) => PhotoApiProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
         home: ToDoPage(),
      ),
    );
  }
}
