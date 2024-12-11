import 'package:api/ScreenPage/photo_page.dart';
import 'package:api/provider_page/album_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AlbumApiProvider>(context, listen: false).fetchAlbums());
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            const Center(
              child: Text(
                'Album Api',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Title',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _userIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'User ID',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: MaterialButton(
                minWidth: 330,
                color: Colors.lightBlue,
                onPressed: () async {
                  final String title = _titleController.text;
                  final String userId = _userIdController.text;

                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter title')),
                    );
                  } else if (userId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter user ID')),
                    );
                  } else {
                    try {
                      int userIdInt = int.parse(userId);
                      Map<String, dynamic> result = await Provider.of<AlbumApiProvider>(context, listen: false).createAlbum(title, userIdInt);
                      bool success = result["success"];
                      int? statusCode = result["statusCode"];
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Success: $statusCode')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed: $statusCode')),
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text(
                  'Post',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var albumData = Provider.of<AlbumApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        title: const Text('Album Api', style: TextStyle(color: Colors.white)),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.refresh),
          //   onPressed: () {
          //     albumData.fetchAlbums();
          //   },
          // ),
            PopupMenuButton(itemBuilder: (context) => [
              PopupMenuItem(child: Text("Photo"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoPage(),));
              },
              )
            ],)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        onPressed: _showModalBottomSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: albumData.albums.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: albumData.albums.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Title: ${albumData.albums[index].title}'),
              subtitle: Text('User ID: ${albumData.albums[index].userId}'),
            ),
          );
        },
      ),
    );
  }
}
