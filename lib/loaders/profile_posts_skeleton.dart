import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePostSkeleton extends StatefulWidget {
  const ProfilePostSkeleton();

  @override
  State<ProfilePostSkeleton> createState() => _ProfilePostSkeletonPageState();
}

class _ProfilePostSkeletonPageState extends State<ProfilePostSkeleton> {
  bool _enabled = true;
  List<String> fakeImageUrls = List.generate(
    15,
    (index) => 'https://via.placeholder.com/150?text=Face${index + 1}',
  );

Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: _enabled,
      child: SingleChildScrollView(
          key: const PageStorageKey<String>('profile'),
          child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              children: [
                for (var imageUrl in fakeImageUrls)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                         imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
              ]
          )
      )
    );
  }
}
