import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluxxmessanger/Pages/callpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart'; // Import the Vibration package
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  final String userName;
  final String receiverID;
  // final String imageURL;

  const ChatPage({Key? key, required this.userName, required this.receiverID})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  List<dynamic> _messages = [];
  String receiverID = '';
  String senderID = '';

  Future<List<dynamic>> _fetchMessages(String id1, String id2) async {
    final response = await http.get(
        Uri.parse('https://chat-backend-22si.onrender.com/messages/$id1/$id2'));
    print(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final jsonData = jsonDecode(response.body);
      final List<dynamic> messages = jsonData['messages'];
      return messages;
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  void setMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senderID = prefs.getString('_id')!;
    final messages = await _fetchMessages(senderID, receiverID);
    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userName = widget.userName;
    receiverID = widget.receiverID;
    setMessages();

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
        ),
        backgroundColor: Colors.transparent,
        elevation: 20,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const CircleAvatar(
                // backgroundImage: AssetImage('assets/profile_image.png'),
                radius: 20,
                child: Icon(Icons.person),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              userName,
              style: const TextStyle(fontSize: 17),
            ),
            const Spacer(),
            _buildPopupMenuButton(context),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return MessageBubble(message: message, myID: senderID);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 0),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _selectFile,
                ),
                const SizedBox(width: 0), // Adjust the width here
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10), // Adjust the padding here
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                    ),
                    child: TextField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      decoration: const InputDecoration(
                        hintText: 'Type a Message...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 0), // Adjust the width here
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _capturePhoto,
                ),
                const SizedBox(width: 0), // Adjust the width here
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: _recordAudio,
                ),
                const SizedBox(width: 0), // Adjust the width here
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // Adjust the radius as needed
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'voice_call',
          child: ListTile(
            leading: Icon(Icons.phone),
            title: Text('Voice Call'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'video_call',
          child: ListTile(
            leading: Icon(Icons.videocam),
            title: Text('Video Call'),
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == 'voice_call') {
          // Navigate to voice call page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CallPage(participantName: ''),
            ),
          );
        } else if (value == 'video_call') {
          // Navigate to video call page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CallPage(participantName: ''),
            ),
          );
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void _selectFile() {
    // Handle file selection
  }

  void _capturePhoto() {
    // Handle photo capture
  }

  void _recordAudio() {
    // Handle audio recording
  }

  void _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      final response = await addMessage(messageText);
      if (response.statusCode == 201) {
        // Message sent successfully
        _messageController.clear();
      } else {
        // Error occurred while sending message
        print('Error sending message: ${response.body}');
        // Handle error accordingly
      }
    }
  }

  Future<http.Response> addMessage(String messageText) async {
    // final now = DateTime.now();
    // final formattedTime = '${now.hour}:${now.minute}';
    final newMessage = {
      'senderId': senderID,
      'receiverId': receiverID,
      'content': messageText, // 'sent', 'delivered', 'read'
    };

    // Convert the newMessage map to JSON format
    final jsonData = json.encode(newMessage);
    print(jsonData);
    // Make a POST request to the API endpoint to send the message
    final response = await http.post(
      Uri.parse('https://chat-backend-22si.onrender.com/send-message'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    return response;
  }
}

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final String myID;

  const MessageBubble({Key? key, required this.message, required this.myID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String text = message['content'];
    final String sender = message['senderId'];
    final String time = message['timestamp'];
    final bool isMe = sender == myID;

    return GestureDetector(
      onLongPress: () {
        _showMessageMenu(context); // Show the menu on long press
        Vibration.vibrate(duration: 50); // Trigger haptic feedback
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 1),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF0050FF) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 100, // Height of the menu
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.reply),
                onPressed: () {
                  // Handle reply action
                  Navigator.pop(context); // Close the menu
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward),
                onPressed: () {
                  // Handle forward action
                  Navigator.pop(context); // Close the menu
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Handle delete action
                  Navigator.pop(context); // Close the menu
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Handle edit action
                  Navigator.pop(context); // Close the menu
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
