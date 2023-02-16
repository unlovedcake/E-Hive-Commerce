import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import '../../model/post-model.dart';

class Sample extends StatefulWidget {
  const Sample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  final controller = ScrollController();
  int page = 1;
  List<String> items = [];
  bool hasmore = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<Post> postAdd = [];

  Future fetch() async {
    const limited = 25;

    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=$limited&_page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List newlist = json.decode(response.body);

      List<Post> post = [];

      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      post = parsed.map<Post>((json) => Post.fromJson(json)).toList();

      setState(() {
        page++;

        if (post.length < limited) {
          hasmore = false;
        }
        postAdd.addAll(post.map<Post>((items) {
          return Post(userId: items.userId, id: items.id, title: items.title, body: items.body);
        }).toList());

        print(postAdd.toString());
        print(postAdd.length.toString());
        print("ssa");

        if (newlist.length < limited) {
          hasmore = false;
        }
        items.addAll(newlist.map<String>((items) {
          final number = items['id'];
          return 'item $number';
        }).toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(5),
          controller: controller,
          itemCount: postAdd.length + 1,
          itemBuilder: (context, index) {
            if (index < postAdd.length) {
              final item = postAdd[index];
              return ListTile(
                title: Text(item.title),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: hasmore
                      ? const CircularProgressIndicator()
                      : const Text('No More Data To Load'),
                ),
              );
            }
          }),
      // body: ListView.builder(
      //     padding: const EdgeInsets.all(5),
      //     controller: controller,
      //     itemCount: items.length + 1,
      //     itemBuilder: (context, index) {
      //       if (index < items.length) {
      //         final item = items[index];
      //         return ListTile(
      //           title: Text(item),
      //         );
      //       } else {
      //         return Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 30),
      //           child: Center(
      //             child: hasmore
      //                 ? const CircularProgressIndicator()
      //                 : const Text('No More Data To Load'),
      //           ),
      //         );
      //       }
      //     }),
    );
  }
}
