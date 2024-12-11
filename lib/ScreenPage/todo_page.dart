import 'package:api/ScreenPage/post_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider_page/get_provider.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<GetProvider>(context, listen: false).callToDoApi());
  }

  @override
  Widget build(BuildContext context) {
    var apiData = Provider.of<GetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('ToDo Api', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
        actions: [
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Post Api'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage()));
                },
              ),
            ],
          ),
        ],
      ),
      body: apiData.toDoList == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: apiData.toDoList?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Title: ${apiData.toDoList?[index].title}'),
              subtitle: Text('Body: ${apiData.toDoList?[index].userId}'),
            ),
          );
        },
      ),
    );
  }
}
