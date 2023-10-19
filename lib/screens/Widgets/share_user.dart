import 'package:flutter/material.dart';

class UserSearchModal extends StatefulWidget {
  @override
  _UserSearchModalState createState() => _UserSearchModalState();
}

class _UserSearchModalState extends State<UserSearchModal> {
  TextEditingController _searchController = TextEditingController();
  List<String> _users = ['User 1', 'User 2', 'User 3', 'User 4']; // Replace with your user data

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement your search logic here
                // You can filter the user list based on the search input
                // For simplicity, we'll update the list with all users
                setState(() {
                  _users = ['User 1', 'User 2', 'User 3', 'User 4']; // Replace with your user data
                });
              },
            ),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 300.0), // Set a max height for the list
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_users[index]),
                  onTap: () {
                    // Handle user selection here
                    // You can close the modal and pass selected user data back to the parent widget
                    Navigator.pop(context, _users[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
