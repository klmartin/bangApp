import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/models/post.dart';
import 'package:bangapp/providers/posts_provider.dart'; // Import your PostsProvider class
import '../../providers/image_upload.dart';
import '../../providers/payment_provider.dart';
import '../../providers/video_upload.dart';
import '../Widgets/image_upload.dart';
import '../Widgets/post_item2.dart';
import '../Widgets/small_box2.dart';
import 'package:bangapp/providers/user_provider.dart';

import '../Widgets/video_upload.dart';

class Home2 extends StatelessWidget  {
  String? video;
  final Map<String, String>? videoBody;

  Home2({this.video, this.videoBody});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home2Content(),
    );
  }
}

class Home2Content extends StatefulWidget  {
  @override
  _Home2ContentState createState() => _Home2ContentState();
}

class _Home2ContentState extends State<Home2Content> with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;
  late VideoUploadProvider videoUploadProvider; // Declare it here
  late ImageUploadProvider imageUploadProvider;
  late PaymentProvider paymentProvider;
  double _scrollPosition = 0.0;
  @override
  void initState() {
    super.initState();
    videoUploadProvider =Provider.of<VideoUploadProvider>(context, listen: false);
    imageUploadProvider =Provider.of<ImageUploadProvider>(context, listen: false);
    paymentProvider = Provider.of<PaymentProvider>(context, listen:false);
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    postsProvider.fetchData(_pageNumber);

    videoUploadProvider.addListener(() {
      if (videoUploadProvider.uploadText == 'Upload Complete') {
        print('this is a new post');
        postsProvider.refreshData();
        _scrollController.jumpTo(0);
      }

    });

    paymentProvider.addListener(() {
      if (paymentProvider.isFinishPaying == true) {
        postsProvider.deletePinnedById(paymentProvider.payedPost);
      }
    });

    imageUploadProvider.addListener(() {
      if(imageUploadProvider.uploadText == 'Upload Complete'){
        print('this is an image post');
        postsProvider.refreshData();
        _scrollController.jumpTo(0);
      }
    });


    _scrollController.addListener(() {
      _scrollPosition = _scrollController.offset;
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _pageNumber++;

      postsProvider.loadMoreData(_pageNumber); // Trigger loading of the next page
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
    final userProvider = Provider.of<UserProvider>(context);
    print(userProvider.userData);
    print('this is userdata');
    if (userProvider.userData.isEmpty) {
      userProvider.fetchUserData();
    }
    return RefreshIndicator(
      onRefresh: () async {
        final postsProvider =
            Provider.of<PostsProvider>(context, listen: false);
        postsProvider.refreshData();
        _scrollController.jumpTo(0);
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
        child: errorDialog(size: 10),
      );
    } else if (postsProvider.posts == null || postsProvider.posts!.isEmpty) {
      return Center(
        child: Text("No posts available."),
      );
    }

    return ListView.builder(
      key: const PageStorageKey<String>('page'),
      controller: _scrollController, // Attach the ScrollController
      itemCount: postsProvider.posts!.length + 1,
      itemBuilder: (context, index) {
        if (index < postsProvider.posts!.length) {
          final Post post = postsProvider.posts![index];
          // Service().updateIsSeen(post.postId);
          if (index == 0) {
            return Column(
              children: [
                SmallBoxCarousel(),
                imageUploadProvider.isUploading ? ImageUpload() : Container(),
                videoUploadProvider.isUploading ? VideoUpload() : Container(),
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
                  post.cacheUrl,
                  post.thumbnailUrl,
                  post.aspectRatio,
                  post.price,
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
              post.cacheUrl,
              post.thumbnailUrl,
              post.aspectRatio,
              post.price,
              myProvider: postsProvider,
            );
          }
        } else if (postsProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (!postsProvider.isLastPage) {
          return ElevatedButton(
            onPressed: () {
              postsProvider
                  .fetchData(_pageNumber); // Trigger loading of the next page
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
              postsProvider.fetchData(_pageNumber);
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



