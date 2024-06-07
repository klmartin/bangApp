import 'package:bangapp/models/post.dart';
import 'package:bangapp/screens/Widgets/image_upload.dart';
import 'package:bangapp/screens/Widgets/post_item2.dart';
import 'package:bangapp/screens/Widgets/small_box2.dart';
import 'package:bangapp/screens/Widgets/video_upload.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/providers/auth_provider.dart';
import 'package:bangapp/providers/posts_provider.dart';
import 'package:bangapp/providers/profile_provider.dart';
import 'package:bangapp/providers/challenge_upload.dart';
import 'package:bangapp/providers/image_upload.dart';
import 'package:bangapp/providers/payment_provider.dart';
import 'package:bangapp/providers/video_upload.dart';
import 'package:bangapp/providers/user_provider.dart';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/loaders/home_skeleton.dart';

class Home2 extends StatelessWidget {
  Home2();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      // Redirect to login if not authenticated
      Future.microtask(() {
        Navigator.of(context).pushReplacementNamed(
            '/login'); // Ensure you have a route named '/login'
      });
      return Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Placeholder until navigation completes
      );
    }

    return Scaffold(
      body: Home2Content(),
    );
  }
}

class Home2Content extends StatefulWidget {
  @override
  _Home2ContentState createState() => _Home2ContentState();
}

class _Home2ContentState extends State<Home2Content>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;

  late VideoUploadProvider _videoUploadProvider;
  late ImageUploadProvider _imageUploadProvider;
  late PaymentProvider _paymentProvider;
  late ChallengeUploadProvider _challengeUploadProvider;

  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeProviders();
    _initializeListeners();
    _fetchInitialData();
    _scrollController.addListener(_scrollListener);
  }

  void _initializeProviders() {
    _videoUploadProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);
    _imageUploadProvider =
        Provider.of<ImageUploadProvider>(context, listen: false);
    _paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    _challengeUploadProvider =
        Provider.of<ChallengeUploadProvider>(context, listen: false);
  }

  void _initializeListeners() {
    _videoUploadProvider.addListener(_handleUploadComplete);
    _imageUploadProvider.addListener(_handleUploadComplete);
    _challengeUploadProvider.addListener(_handleUploadComplete);

    _paymentProvider.addListener(() {
      if (_paymentProvider.payed == true) {
        final postsProvider =
            Provider.of<PostsProvider>(context, listen: false);
        postsProvider.deletePinnedById(_paymentProvider.payedPost);
      }
    });
  }

  void _fetchInitialData() {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    postsProvider.fetchData(_pageNumber);
  }

  void _handleUploadComplete() {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    if (_videoUploadProvider.uploadText == 'Upload Complete' ||
        _imageUploadProvider.uploadText == 'Upload Complete' ||
        _challengeUploadProvider.uploadText == 'Upload Complete') {
      postsProvider.refreshData();
      _scrollController.jumpTo(0);
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.getMyPosts(1);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _pageNumber++;
      final postsProvider = Provider.of<PostsProvider>(context, listen: false);
      postsProvider.loadMoreData(_pageNumber);
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
    super.build(
        context); // Must call super.build for AutomaticKeepAliveClientMixin to work

    final userProvider = Provider.of<UserProvider>(context);
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
      return const Center(child: HomeSkeleton());
    } else if (postsProvider.isError) {
      return Center(child: errorDialog(size: 10));
    } else if (postsProvider.posts == null || postsProvider.posts!.isEmpty) {
      return Center(child: Text("No posts available."));
    }

    return ListView.builder(
      key: const PageStorageKey<String>('page'),
      controller: _scrollController,
      itemCount: postsProvider.posts!.length + 1,
      itemBuilder: (context, index) {
        if (index < postsProvider.posts!.length) {
          final Post post = postsProvider.posts![index];
          Service().updateIsSeen(post.postId);
          return _buildPostItem(post, index, postsProvider);
        } else if (postsProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (!postsProvider.isLastPage) {
          return ElevatedButton(
            onPressed: () => postsProvider.fetchData(_pageNumber),
            child: Text('Load More'),
          );
        } else {
          return Center(child: Text('No more posts to load.'));
        }
      },
    );
  }

  Widget _buildPostItem(Post post, int index, PostsProvider postsProvider) {
    if (index == 0) {
      return Column(
        children: [
          SmallBoxCarousel(),
          _buildUploadWidget(_imageUploadProvider),
          _buildUploadWidget(_challengeUploadProvider),
          _buildUploadWidget(_videoUploadProvider),
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
            post.postViews,
            myProvider: postsProvider,
          ),
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
        post.postViews,
        myProvider: postsProvider,
      );
    }
  }

  Widget _buildUploadWidget(dynamic uploadProvider) {
    if (uploadProvider.isUploading) {
      if (uploadProvider is ImageUploadProvider) {
        return ImageUpload();
      } else if (uploadProvider is VideoUploadProvider) {
        return VideoUpload();
      } else {
        return Container(); // Handle other upload types here
      }
    }
    return Container();
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
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              final postsProvider =
                  Provider.of<PostsProvider>(context, listen: false);
              postsProvider.refreshData();
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
