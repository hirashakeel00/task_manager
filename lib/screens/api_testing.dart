import 'package:flutter/material.dart';
import 'package:task_manager/services/api_service.dart';

class ApiTesting extends StatefulWidget {
  const ApiTesting({super.key});

  @override
  State<ApiTesting> createState() => _ApiTestingState();
}

class _ApiTestingState extends State<ApiTesting> {
  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
  final data = await ApiService().getPosts();
  setState(() {
    posts = data;
    isLoading = false;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return ListTile(
  title: Text(post['title']),
  subtitle: Text(
    post['body'],
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  ),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          await ApiService().updatePost(post['id']);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Update API Called'),
            ),
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await ApiService().deletePost(post['id']);

          setState(() {
            posts.removeAt(index);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Delete API Called'),
            ),
          );
        },
      ),
    ],
  ),
);
              },
            ),
    );
  }
}
