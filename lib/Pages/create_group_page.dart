import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  List<User> _users = []; // List of available users
  List<User> _selectedUsers = []; // List of users selected for the new group

  @override
  void initState() {
    super.initState();
    // Fetch user data from API
    _fetchUsers();
  }

  void _fetchUsers() async {
    final response = await http
        .get(Uri.parse('https://chat-backend-22si.onrender.com/users'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> usersJson = jsonData['users'];

      List<User> fetchedUsers = usersJson.map((userJson) {
        return User(
          id: userJson['_id'],
          name: userJson['username'],
          phone: userJson['phone'],
          // Add other properties as needed
        );
      }).toList();

      setState(() {
        _users = fetchedUsers;
      });
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  void _toggleUserSelection(User user) {
    setState(() {
      if (_selectedUsers.contains(user)) {
        _selectedUsers.remove(user);
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  Future<void> _createGroup() async {
    final List<String> memberIds =
        _selectedUsers.map((user) => user.id).toList();
    final String groupName = _groupNameController.text;

    try {
      final response = await http.post(
        Uri.parse('https://chat-backend-22si.onrender.com/group'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': groupName,
          'members': memberIds,
        }),
      );

      if (response.statusCode == 201) {
        // Group created successfully
        // You can navigate to another page or show a success message
        Navigator.pop(context);
      } else {
        // Error creating group
        // Show an error message
        print(response.body);
      }
    } catch (error) {
      // Handle network error
      print('Error creating group: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _createGroup,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              'Group Name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _groupNameController,
              decoration: InputDecoration(
                hintText: 'Enter group name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            Text(
              'Select Members',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(child: _buildUserList()),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (BuildContext context, int index) {
        final user = _users[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: ListTile(
            title: Text(user.name),
            subtitle: Text(user.phone),
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            trailing: Checkbox(
              value: _selectedUsers.contains(user),
              onChanged: (bool? isChecked) {
                if (isChecked != null) {
                  _toggleUserSelection(user);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class User {
  final String id;
  final String name;
  final String phone;

  User({required this.id, required this.name, required this.phone});
}
