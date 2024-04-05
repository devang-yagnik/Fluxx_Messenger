import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart'; // Import the Vibration package

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  List<dynamic> _messages = [];
  String senderID = '';

  @override
  void initState() {
    super.initState();
    setMessages();
  }

  Future<List<dynamic>> _fetchMessages(String groupId) async {
    final response = await http.get(
      Uri.parse(
          'https://chat-backend-22si.onrender.com/group-messages/$groupId'),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> messages = jsonData['groupMessages'];
      return messages;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void setMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senderID = prefs.getString('_id')!;
    final messages = await _fetchMessages(widget.groupId);
    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              widget.groupName,
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
                print(message);
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      borderRadius: BorderRadius.circular(50),
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
          value: 'leave_group',
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Leave Group'),
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == 'leave_group') {
          // Implement leaving group functionality
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
      final response = await http.post(
        Uri.parse('https://chat-backend-22si.onrender.com/send-group-message'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'groupID': widget.groupId,
          'senderID': senderID,
          'content': messageText,
        }),
      );
      if (response.statusCode == 201) {
        _messageController.clear();
        setMessages(); // Refresh messages after sending
      } else {
        print('Failed to send group message');
      }
    }
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
    final String sender = message['senderID'];
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
