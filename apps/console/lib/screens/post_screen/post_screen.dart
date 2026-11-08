import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/controllers/post_controller.dart';
import 'package:mona_console/screens/post_screen/components/post_list.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(PostController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿一覧', style: TextStyle(color: kBodyTextColor)),
      ),
      body: const SafeArea(child: PostSection()),
    );
  }
}
