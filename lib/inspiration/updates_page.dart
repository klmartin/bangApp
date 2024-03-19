
import 'dart:convert';

import 'package:bangapp/inspiration/view_video.dart';
import 'package:bangapp/providers/inprirations_Provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../constants/urls.dart';
import '../services/token_storage_helper.dart';

class BangInspirationBuilder extends StatefulWidget {

  _BangInspirationBuilder createState() => _BangInspirationBuilder();

}

class _BangInspirationBuilder extends State<BangInspirationBuilder> {
  @override
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _fetchInspoResults(String keyword) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse('$baseUrl/get/bangInspirations?search_string=$keyword');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Include other headers as needed
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _searchResults = data.cast<Map<String, dynamic>>();
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  Widget build(BuildContext context) {
    return Consumer<BangInspirationsProvider>(
      builder: (context, provider, child) {
        // Assuming fetchInspirations is a Future<void> function in your provider
        if (!provider.isFetched) {
          provider.fetchInspirations(context);
        }
          // Data has been loaded successfully
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.only(left: 5, right: 5, top: 5),
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 60,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _fetchInspoResults(value);
                            } else {
                              setState(() {
                                _searchResults = [];
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Search Bang Inspirations...',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search,color: Colors.black),
                              onPressed: () {
                                // Handle search action here
                                String searchQuery = _searchController.text;
                                _fetchInspoResults(searchQuery);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 5),
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    children: [
                      for (var i = 0; i < provider.inspirations.length; i++)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewVideo(
                                    provider.inspirations[i].id,
                                    provider.inspirations[i].title,
                                    'The Codeholic',
                                    provider.inspirations[i].videoUrl,
                                      provider.inspirations[i].thumbnail

                                  ),
                                ),
                              );
                            },
                            child:
                            CachedNetworkImage(
                              imageUrl: provider.inspirations[i].thumbnail!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                    ],
                  )

                ],
              ),
            ),
          );

      },
    );
  }
}
