import 'dart:convert';
import 'package:bangapp/providers/BoxDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/models/post.dart';
import 'package:bangapp/providers/posts_provider.dart'; // Import your PostsProvider class
import 'package:bangapp/screens/Widgets/post_item.dart';
import '../Widgets/post_item2.dart';
import '../Widgets/small_box2.dart';
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
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    postsProvider.fetchData();

    _scrollController = ScrollController()
      ..addListener(() {
        // This checks if the ListView has been scrolled all the way to the bottom.
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        }
      });

  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final postsProvider = Provider.of<PostsProvider>(context, listen: false);

        // postsProvider.refreshData();
      },
      child: Consumer<PostsProvider>(
        builder: (context, postsProvider, child) {
          return buildPostsView(postsProvider);
        },
      ),
    );
  }

@override
  void dispose() {
    _scrollController.dispose();  // Dispose the ScrollController when the widget is removed
    super.dispose();
  }

  Widget buildPostsView(PostsProvider postsProvider) {
    if (postsProvider.isLoading) {
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
      itemCount: postsProvider.posts!.length,
      itemBuilder: (context, index) {
        final Post post = postsProvider.posts![index];

        if(index == 0){

  return Column(
    children: [
      SmallBoxCarousel(),

        PostItem2(
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
        post.isLikedA,
        post.isLikedB,
        post.createdAt,
        myProvider: postsProvider,
        )
    ],
  );
}
        // int adjustedIndex = index - (index ~/ 8);
        // if (adjustedIndex < 0 || adjustedIndex >= postsProvider.posts!.length) {
        //   return const SizedBox(); // Return an empty widget if the index is out of bounds
        // }
        // if (index == 0 || (index >= 8 && (index - 8) % 8 == 0)) {
        //   return Column(
        //     children: [
        //       SmallBoxCarousel(),
        //       PostItem2(
        //         post.postId,
        //         post.userId,
        //         post.name,
        //         post.image,
        //         post.challengeImg,
        //         post.caption,
        //         post.type,
        //         post.width,
        //         post.height,
        //         post.likeCountA,
        //         post.likeCountB,
        //         post.commentCount,
        //         post.followerCount,
        //         post.challenges,
        //         post.isLiked,
        //         post.isPinned,
        //         post.isLikedA,
        //         post.isLikedB,
        //         post.createdAt,
        //         myProvider: postsProvider,
        //       ),
        //     ],
        //   );
        // } else {
        //   if (adjustedIndex == postsProvider.posts!.length - postsProvider.nextPageTrigger) {
        //     postsProvider.fetchData();
        //   }
        //   if (adjustedIndex == postsProvider.posts!.length) {
        //     if (postsProvider.isError) {
        //       return Center(
        //         child: errorDialog(size: 15),
        //       );
        //     } else {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //   }
else{

  return PostItem2(
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
    post.isLikedA,
    post.isLikedB,
    post.createdAt,
    myProvider: postsProvider,
  );
}
        }


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
            //   postsProvider.refreshData();
            },
            child: const Text("Retry", style: TextStyle(fontSize: 20, color: Colors.purpleAccent),),
          ),
        ],
      ),
    );
  }
}

