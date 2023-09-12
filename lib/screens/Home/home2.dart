import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/models/post.dart';
import 'package:bangapp/providers/posts_provider.dart'; // Import your PostsProvider class
import 'package:bangapp/screens/Widgets/post_item.dart';
import '../Widgets/small_box.dart';
import 'package:bangapp/constants/urls.dart';

class Home2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => PostsProvider(),
        child: Home2Content(),
      ),
    );
  }
}

class Home2Content extends StatefulWidget {
  @override
  _Home2ContentState createState() => _Home2ContentState();
}

class _Home2ContentState extends State<Home2Content> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!postsProvider.isLoading && !postsProvider.isLastPage) {
          postsProvider.fetchData();
        }
      }
    });
    postsProvider.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        postsProvider.refreshData();
      },
      child: buildPostsView(postsProvider),
    );
  }Widget buildPostsView(PostsProvider postsProvider) {
  if (postsProvider.isLoading && (postsProvider.posts == null || postsProvider.posts!.isEmpty)) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  } else if (postsProvider.isError) {
    return Center(
      child: errorDialog(size: 20),
    );
  } else if (postsProvider.posts == null || postsProvider.posts!.isEmpty) {
    return Center(
      child: Text("No posts available."),
    );
  }

  return ListView.builder(
    controller: _scrollController,
    itemCount: postsProvider.posts!.length + (postsProvider.isLastPage ? 0 : 1),
    itemBuilder: (context, index) {
      if (index == 0) {
        return SmallBoxCarousel();
      }
      int adjustedIndex = index - (index ~/ 8);
      if (adjustedIndex < 0 || adjustedIndex >= postsProvider.posts!.length) {
        return const SizedBox(); // Return an empty widget if the index is out of bounds
      }
      final Post post = postsProvider.posts![adjustedIndex];
      if (index == 0 || (index >= 8 && (index - 8) % 8 == 0)) {
        return Column(
          children: [
            SmallBoxCarousel(),
            PostItem(
              post.postId,
              post.userId,
              post.name,
              post.image,
              post.challengeImg,
              post.caption,
              post.type,
              post.width,
              post.height,
              post.likeCountA,
              post.likeCountB,
              post.commentCount,
              post.followerCount,
              post.challenges,
              post.isLiked,
              post.isPinned,
            ),
          ],
        );
      } else {
        if (adjustedIndex == postsProvider.posts!.length - postsProvider.nextPageTrigger) {
          postsProvider.fetchData();
        }
        if (adjustedIndex == postsProvider.posts!.length) {
          if (postsProvider.isError) {
            return Center(
              child: errorDialog(size: 15),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        return PostItem(
          post.postId,
          post.userId,
          post.name,
          post.image,
          post.challengeImg,
          post.caption,
          post.type,
          post.width,
          post.height,
          post.likeCountA,
          post.likeCountB,
          post.commentCount,
          post.followerCount,
          post.challenges,
          post.isLiked,
          post.isPinned,
        );
      }
    },
  );
}

  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the posts.',
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10,),
          TextButton(
            onPressed: () {
              final postsProvider = Provider.of<PostsProvider>(context, listen: false);
              postsProvider.refreshData();
            },
            child: const Text("Retry", style: TextStyle(fontSize: 20, color: Colors.purpleAccent),),
          ),
        ],
      ),
    );
  }
}
