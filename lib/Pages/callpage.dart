import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler package

class CallPage extends StatefulWidget {
  final String participantName;

  const CallPage({Key? key, required this.participantName}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool _isVideoOn = true;
  bool _isAudioOn = true;

  @override
  void initState() {
    super.initState();
    _initPermissions(); // Initialize permissions when the widget is initialized
  }

  Future<void> _initPermissions() async {
    // Request microphone and camera permissions
    await [
      Permission.microphone,
      Permission.camera,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the aspect ratio for the video screens
    const aspectRatio = 1.0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64), // Set the height of the app bar
        child: AppBar(
          backgroundColor: Colors.black
              .withOpacity(0.1), // Transparent with a slight black hue
          elevation: 0, // Remove the shadow
          title: Padding(
            padding: const EdgeInsets.only(
                bottom: 8), // Add padding to move the text to the bottom
            child: Text(
              widget.participantName,
              style: const TextStyle(
                  color: Colors.black, fontSize: 16), // Adjust font size
            ),
          ),
          centerTitle: true, // Center the title
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width *
                      aspectRatio, // Adjust height based on aspect ratio
                  color: const Color.fromARGB(
                      255, 0, 0, 0), // Placeholder for other user's video
                ),
                SizedBox(
                  height: 1,
                  child: Container(color: Colors.white), // White line
                ), // White line
                Container(
                  height: MediaQuery.of(context).size.width *
                      aspectRatio, // Adjust height based on aspect ratio
                  color: const Color.fromARGB(
                      255, 0, 0, 0), // Placeholder for user's video
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isAudioOn ? Icons.mic : Icons.mic_off),
                  onPressed: () {
                    setState(() {
                      _isAudioOn = !_isAudioOn;
                      // Control microphone based on state
                      _isAudioOn ? _enableMicrophone() : _disableMicrophone();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(_isVideoOn ? Icons.videocam : Icons.videocam_off),
                  onPressed: () {
                    setState(() {
                      _isVideoOn = !_isVideoOn;
                      // Control camera based on state
                      _isVideoOn ? _enableCamera() : _disableCamera();
                    });
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Handle end call
                _endCall();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('End Call', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // Method to enable microphone
  Future<void> _enableMicrophone() async {
    // Code to enable microphone
  }

  // Method to disable microphone
  Future<void> _disableMicrophone() async {
    // Code to disable microphone
  }

  // Method to enable camera
  Future<void> _enableCamera() async {
    // Code to enable camera
  }

  // Method to disable camera
  Future<void> _disableCamera() async {
    // Code to disable camera
  }

  // Method to end call
  void _endCall() {
    // Code to end the call
  }
}
