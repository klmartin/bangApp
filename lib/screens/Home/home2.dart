import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/models/post.dart';
import 'package:bangapp/providers/posts_provider.dart'; // Import your PostsProvider class
import '../Widgets/post_item2.dart';
import '../Widgets/small_box2.dart';
import 'package:bangapp/services/service.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    postsProvider.fetchData();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !postsProvider.isLoading &&
        !postsProvider.isLastPage) {
      postsProvider.fetchData(); // Trigger loading of the next page
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final postsProvider =
            Provider.of<PostsProvider>(context, listen: false);
        // postsProvider.refreshData();
      },
      child: Consumer<PostsProvider>(
        builder: (context, postsProvider, child) {
          return buildPostsView(postsProvider);
        },
      ),
    );
  }

  Widget buildPostsView(PostsProvider postsProvider) {
    if (postsProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (postsProvider.isError) {
      return Center(
        child: Text(""),
      );
    } else if (postsProvider.posts == null || postsProvider.posts!.isEmpty) {
      return Center(
        child: Text("No posts available."),
      );
    }

    return ListView.builder(
    controller: _scrollController, // Attach the ScrollController
      itemCount: postsProvider.posts!.length + 1,
      itemBuilder: (context, index) {
        if (index < postsProvider.posts!.length) {
          final Post post = postsProvider.posts![index];
        //   Service().updateIsSeen(post.postId);

          if (index == 0) {
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
                  post.userImage,
                  myProvider: postsProvider,
                )
              ],
            );
          } else {
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
              post.userImage,
              myProvider: postsProvider,
            );
          }
        } else if (postsProvider.isLoading) {
          // Loading indicator while fetching the next page of posts
          return Center(child: CircularProgressIndicator());
        } else if (!postsProvider.isLastPage) {
          // "Load More" button
          return ElevatedButton(
            onPressed: () {
              postsProvider.fetchData(); // Trigger loading of the next page
            },
            child: Text('Load More'),
          );
        } else {
          // No more posts to load
          return Center(child: Text('No more posts to load.'));
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
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              final postsProvider =
                  Provider.of<PostsProvider>(context, listen: false);
              //   postsProvider.refreshData();
            },
            child: const Text(
              "Retry",
              style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
            ),
          ),
        ],
      ),
    );
  }
}
