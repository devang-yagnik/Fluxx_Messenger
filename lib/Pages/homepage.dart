import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for accessing clipboard
import 'package:fluxxmessanger/Pages/TNCpage.dart';
import 'package:fluxxmessanger/Pages/aboutuspage.dart';
import 'package:fluxxmessanger/Pages/chatpage.dart';
import 'package:fluxxmessanger/Pages/premiumpage.dart';
import 'package:fluxxmessanger/Pages/settingspage.dart';
import 'package:fluxxmessanger/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _profileImage;
  String userName = 'Unknown';

  void getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('userName')!;
    // print(prefs);
    setState(() {
      userName = user;
    });
  }

  @override
  void initState() {
    super.initState();
    getName();
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  Future<List<dynamic>> _fetchUserData() async {
    final response = await http
        .get(Uri.parse('https://chat-backend-22si.onrender.com/all-data'));
    print(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final jsonData = jsonDecode(response.body);
      final List<dynamic> users = jsonData['users'];
      return users;
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  Future<Iterable<Contact>> _fetchContacts() {
    return ContactsService.getContacts();
  }

  Future<void> _requestContactPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      // Permission granted, fetch contacts
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGroupPage(
            contactsFuture: _fetchContacts(),
          ),
        ),
      );
    } else {
      // Permission denied, handle accordingly
      // For now, we can show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact permission denied.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Adjust the height as needed
        child: Container(
          padding: const EdgeInsets.only(
            top: 0, // Adjust the top padding as needed
            left: 0, // Adjust the left padding as needed
            right: 0, // Adjust the right padding as needed
            bottom: 0, // Adjust the right padding as needed
          ),
          child: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15), // Adjust the radius as needed
            ),
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            elevation: 30,
            automaticallyImplyLeading: false, // Remove back button
            title: const Text('Fluxx'), // Change title text
            actions: [
              IconButton(
                icon: const Icon(Icons.menu), // Hamburger icon
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ],
          ),
        ),
      ),
      endDrawer: Padding(
        padding: const EdgeInsets.only(
            top: 30, right: 10, bottom: 20), // Add padding to the right
        child: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Adjust the radius as needed
          ),
          backgroundColor: const Color.fromARGB(
              255, 255, 255, 255), // Set background color to white
          width: MediaQuery.of(context).size.width * 0.55,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  // Gradient
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFF5800),
                          Color(0xFF0050FF),
                          Color(0xFFA400FF),
                        ],
                        stops: [0.2, 0.6, 0.8],
                        begin: AlignmentDirectional(-1, 0.98),
                        end: AlignmentDirectional(1, -0.98),
                      ),
                    ),
                  ),
                  // Overlay
                  Positioned.fill(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Color(0x00FFFFFF),
                            Color.fromARGB(255, 245, 245, 245),
                          ],
                          stops: [0, 0, 0.9],
                          begin: AlignmentDirectional(0, -1),
                          end: AlignmentDirectional(0, 1),
                        ),
                      ),
                    ),
                  ),
                  // Profile Picture and Name
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        // Show dialog for profile picture options
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              image: _profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(_profileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _profileImage == null
                                ? const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.group), // Change icon to group icon
                      title: const Text(
                          'Start New Group'), // Change text to "Start New Group"
                      onTap: () {
                        _requestContactPermission(
                            context); // Request contact permission
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text('Invite New User'),
                      onTap: () {
                        // Handle invite new user
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Invite New User'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                      'Let\'s chat on Fluxx! It\'s fast, simple, and secure we can use to message and call each other for free. Get it at https://fluxx.com/dl/'),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Clipboard.setData(const ClipboardData(
                                          text:
                                              'Let\'s chat on Fluxx! It\'s fast, simple, and secure we can use to message and call each other for free. Get it at https://fluxx.com/dl/'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Copied to clipboard'),
                                      ));
                                    },
                                    child: const Text('Copy'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsPage()), // Navigate to SettingsPage
                        ); // Handle settings
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_sharp),
                      title: const Text('T&C'),
                      onTap: () {
                        // Handle settings
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TNCPage()), // Navigate to SettingsPage
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('About Us'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AboutUsPage()), // Navigate to SettingsPage
                        );
                        // Handle about us
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('LogOut'),
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences
                            .getInstance(); // Handle settings
                        prefs.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LandingPage()), // Navigate to SettingsPage
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Footer
              ListTile(
                // leading: const Image(
                //     image: AssetImage('assets/images/fluxxlogo.png')),
                title: const Text(
                  'Fluxx Premium',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 255, 185, 0)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const PremiumPage()), // Navigate to SettingsPage
                  );
                  // Handle Fluxx Premium
                },
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
          future: _fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child:
                    CircularProgressIndicator(), // Display loading indicator while data is being fetched
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                    'Error: ${snapshot.error}'), // Display error message if fetching data fails
              );
            } else {
              List<dynamic> users = snapshot.data!;
              return ListView.builder(
                itemCount:
                    users.length, // Replace with the actual number of chats
                itemBuilder: (context, index) {
                  dynamic user = users[index];
                  return ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        // Show chat profile picture in mini window
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Replace with chat's profile image
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        NetworkImage(user['profilePicture'])
                                            as IconData,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      user['username'],
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                        ),
                        // child: ClipRRect(
                        //   borderRadius: BorderRadius.circular(10),
                        //   child: Image.network(
                        //     user['profilePicture'],
                        //     width: 40,
                        //     height: 40,
                        //     fit: BoxFit.cover,
                        //     color: Colors
                        //         .grey, // Optional: You can set the color of the image
                        //     colorBlendMode: BlendMode
                        //         .color, // Optional: Blend mode for coloring the image
                        //   ),
                        // ),
                      ),
                    ),
                    title: Text(user['username']),
                    subtitle: Text("Last message from ${user['username']}"),
                    onTap: () {
                      // Navigate to the chat screen for the selected chat
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(userName: user['username'].toString(), receiverID: user['_id'].toString()),
                        ),
                      );
                    },
                  );
                },
              );
            }
          }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5.0, bottom: 5.0), // Add padding
        child: FloatingActionButton(
          onPressed: () async {
            await _requestContactPermission(context);
          },
          child: const Icon(Icons.message),
        ),
      ),
    );
  }
}

class CreateGroupPage extends StatelessWidget {
  final Future<Iterable<Contact>> contactsFuture;

  const CreateGroupPage({Key? key, required this.contactsFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
        backgroundColor: const Color.fromARGB(100, 195, 195, 255),
        toolbarHeight: 75,
      ),
      body: FutureBuilder<Iterable<Contact>>(
        future: contactsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  CircularProgressIndicator(), // Loader while contacts are being fetched
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching contacts: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<Contact> contacts = snapshot.data!.toList();
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: ListTile(
                    leading: CircleAvatar(
                      foregroundImage:
                          contact.avatar != null && contact.avatar!.isNotEmpty
                              ? MemoryImage(contact.avatar!)
                              : null,
                      backgroundColor: const Color.fromARGB(155, 155, 155, 255),
                      child: contact.avatar == null || contact.avatar!.isEmpty
                          ? const Icon(Icons.person)
                          : null, // Fallback background color
                    ),
                    title: Text(contact.displayName ?? 'Unknown'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                                userName: contact.displayName ?? 'Unknown', receiverID: 'null',),
                                
                          ));
                      // Handle contact tap
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No contacts found.'),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
