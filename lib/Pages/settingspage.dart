import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 1500,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 89, 0),
                  Color.fromARGB(255, 50, 120, 255),
                  Color.fromARGB(255, 190, 68, 255),
                ],
                stops: [0.45, 0.75, 0.93],
                begin: AlignmentDirectional(-1, 0.98),
                end: AlignmentDirectional(1, -0.98),
              ),
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0x00FFFFFF), Colors.white],
                  stops: [0, 0, 0.85],
                  begin: AlignmentDirectional(0, -1),
                  end: AlignmentDirectional(0, 1),
                ),
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Adjust the radius as needed
                ),
                backgroundColor: Colors.transparent,
                elevation: 30,
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ],
                ),
                centerTitle: false,
                toolbarHeight: 65, // Adjust the height of the app bar
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      InkWell(
                        onTap: () {
                          // Show profile options modal bottom sheet
                          showProfileOptions(context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[300], // Placeholder color
                                borderRadius: BorderRadius.circular(10),
                                // Replace with user's profile picture
                                image: DecorationImage(
                                  image: _profileImage != null &&
                                          File(_profileImage!.path).existsSync()
                                      ? FileImage(File(_profileImage!.path))
                                          as ImageProvider<Object>
                                      : const AssetImage('assets/profile_picture.jpg')
                                          as ImageProvider<Object>,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    //apply preffered function
                                  },
                                  child: Text(
                                    _nameController.text.isNotEmpty
                                        ? _nameController.text
                                        : 'User Name', // Replace with user's name
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                InkWell(
                                  onTap: () {
                                    //apply preffered function
                                  },
                                  child: Text(
                                    _phoneNumberController.text.isNotEmpty
                                        ? _phoneNumberController.text
                                        : '+91 0123456789', // Replace with user's Phone
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 66, 66, 66),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Bio Section
                      InkWell(
                        onTap: () {
                          //apply prefferd function
                        },
                        child: Text(
                          _bioController.text.isNotEmpty
                              ? _bioController.text
                              : 'User Bio goes here...', // Replace with user's bio
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 42, 42, 42),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Settings Options
                      Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      ListTile(
                        title: const Text('Username settings'),
                        onTap: () {
                          showChangeNameDialog(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Phone Number settings'),
                        onTap: () {
                          showChangePhoneNumberDialog(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Bio settings'),
                        onTap: () {
                          showChangeBioDialog(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Email settings'),
                        onTap: () {
                          showChangeEmailDialog(context);
                        },
                      ),
                      // Add more settings options as needed
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _profileImage = imageFile;
      });
    } else {
      // User canceled the picker
    }
  }

  void showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.add_photo_alternate),
                title: const Text('Add Profile Picture'),
                onTap: () async {
                  // Handle add profile picture
                  Navigator.pop(context);
                  await _getImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Update Profile Picture'),
                onTap: () async {
                  // Handle update profile picture
                  Navigator.pop(context);
                  await _getImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle),
                title: const Text('Remove Profile Picture'),
                onTap: () {
                  // Handle remove profile picture
                  setState(() {
                    _profileImage = null;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showChangeNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter new name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update the user's name
                setState(() {
                  // Here you can update the user's name using _nameController.text
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void showChangePhoneNumberDialog(BuildContext context) {
    final TextEditingController phoneNumberController =
        TextEditingController();
    String selectedCountryCode = '+91'; // Default country code

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Phone Number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DropdownButton<String>(
                    value: selectedCountryCode,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCountryCode = newValue!;
                      });
                    },
                    items: <String>[
                      '+91',
                      '+1',
                      '+44',
                      '+86'
                    ] // Add more country codes as needed
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'Enter new phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (phoneNumberController.text.isNotEmpty &&
                          RegExp(r'^[0-9]{10}$')
                              .hasMatch(phoneNumberController.text)) {
                        // Update the user's phone number
                        setState(() {
                          // Here you can update the user's phone number using _phoneNumberController.text
                        });
                        Navigator.of(context).pop();
                      } else {
                        // Show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid phone number'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Update'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showChangeBioDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Bio'),
          content: TextFormField(
            controller: _bioController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Enter new bio',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update the user's bio
                setState(() {
                  // Here you can update the user's bio using _bioController.text
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void showChangeEmailDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change User Email'),
          content: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter new email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(emailController.text)) {
                  // Update the user's email
                  setState(() {
                    // Here you can update the user's email using _emailController.text
                  });
                  Navigator.of(context).pop();
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid email address'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
