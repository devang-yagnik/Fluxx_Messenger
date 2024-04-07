import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallPage extends StatefulWidget {
  final String participantName;
  final String receiverID;

  const CallPage(
      {Key? key, required this.participantName, required this.receiverID})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool _isVideoOn = true;
  bool _isAudioOn = true;
  bool _offerCreated = false;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  late IO.Socket socket;
  late RTCPeerConnection _peerConnection;
  String _receiverID = '';
  String offerID = '';
  final _localRenderer = RTCVideoRenderer(); // Add local renderer
  final _remoteRenderer = RTCVideoRenderer(); // Add remote renderer

  @override
  void initState() {
    super.initState();
    _initPermissions();
    _createLocalStream();
    _initPeerConnection();
    _initSocketConnection();
  }

  void _initSocketConnection() {
    try {
      // Connect to your socket server
      socket = IO.io('wss://chat-backend-22si.onrender.com');

      socket.on('connect', (_) async {
        print('Socket connected, CONGRATULATIONS!!!!!!!!!!!!!!!!!');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String senderID = prefs.getString('_id')!;
        socket.emit('userId', senderID);
      });

      // Define event handlers

      socket.on('disconnect', (_) {
        print('Socket disconnected');
      });

      socket.on('offer_accepted', (data) {
        // Handle offer accepted event
        print('Offer accepted: $data');
      });

      socket.on('answer', (data) {
        String answerSDP = data['sdp'];
        // Use the answerSDP to set the remote description of your peer connection
        _setRemoteDescription(answerSDP);
      });

      // Connect to the socket server
      socket.connect();
    } catch (e) {
      print('Error initializing socket connection: $e');
    }
  }

  void _setRemoteDescription(String answerSDP) {
    try {
      RTCSessionDescription answer = RTCSessionDescription(answerSDP, 'answer');
      // Set the remote description of your peer connection
      _peerConnection.setRemoteDescription(answer);
    } catch (e) {
      print('Error setting remote description: $e');
    }
  }

  Future<void> _initPeerConnection() async {
    // Initialize peer connection configuration
    final Map<String, dynamic> config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    // Create peer connection
    _peerConnection = (await createPeerConnection(config, {}));

    // Add local stream to peer connection
    if (_localStream != null) {
      _peerConnection.addStream(_localStream!);
    }

    // Set up event listeners for remote stream and data channel
    _peerConnection.onAddStream = (MediaStream stream) {
      print('Remote stream received');
      setState(() {
        _remoteStream = stream;
        _remoteRenderer.srcObject = _remoteStream;
      });
    };

    _peerConnection.onDataChannel = (RTCDataChannel channel) {
      print('Data channel received');
      // Handle the data channel if necessary
    };

    // Check for pending offers before creating a new one
    await _checkPendingOffers(_receiverID);
  }

  Future<void> _checkPendingOffers(String receiverID) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String senderID = prefs.getString('_id')!;

      final response = await http.get(
        Uri.parse(
            'https://chat-backend-22si.onrender.com/offers/pending/$receiverID/$senderID'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['pendingOffers'];
        print(data.isNotEmpty);
        if (data.isNotEmpty) {
          final offer = data[0];
          offerID = offer['_id'];
          _acceptOffer(offer['_id']);
        } else {
          print('No pending offers');
          if (!_offerCreated) {
            print('Creating a new offer');
            _createOffer(receiverID);
            _offerCreated = true;
          }
        }
      }
    } catch (e) {
      print('Error checking pending offers: $e');
    }
  }

  Future<void> _acceptOffer(String offerID) async {
    try {
      // Update offer status to accepted
      final response = await http.patch(
        Uri.parse(
            'https://chat-backend-22si.onrender.com/offer/accept/$offerID'),
      );

      if (response.statusCode == 200) {
        print('Offer accepted successfully');

        // Extract offer details from the response
        final offerData = jsonDecode(response.body)['updatedOffer'];
        final offerSDP = offerData['offerSDP'];

        // Set remote description with the offer SDP
        final RTCSessionDescription offer = RTCSessionDescription(
          offerSDP,
          'offer',
        );
        await _peerConnection.setRemoteDescription(offer);

        // Create answer
        final RTCSessionDescription answer =
            await _peerConnection.createAnswer({});
        await _peerConnection.setLocalDescription(answer);

        // Send the answer to the sender
        final Map<String, dynamic> answerData = {
          'answerSDP': answer.sdp,
        };

        final answerResponse = await http.post(
          Uri.parse(
              'https://chat-backend-22si.onrender.com/offer/answer/$offerID'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(answerData),
        );

        if (answerResponse.statusCode == 200) {
          print('Answer sent successfully');
        } else {
          print('Failed to send answer: ${answerResponse.statusCode}');
        }
      } else {
        print('Failed to accept offer: ${response.statusCode}');
      }
    } catch (e) {
      print('Error accepting offer: $e');
    }
  }

  Future<void> _deleteOffer(String offerID) async {
    try {
      final response = await http.delete(
        Uri.parse('https://chat-backend-22si.onrender.com/offer/$offerID'),
      );

      if (response.statusCode == 200) {
        print('Offer deleted successfully');
      } else {
        print('Failed to delete offer: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting offer: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _localStream?.dispose();
    _localRenderer.dispose(); // Dispose local renderer
    _remoteStream?.dispose();
    _remoteRenderer.dispose(); // Dispose remote renderer
    _peerConnection.dispose();
  }

  Future<void> _initPermissions() async {
    await [
      Permission.microphone,
      Permission.camera,
    ].request();
  }

  Future<void> _createOffer(String receiverID) async {
    try {
      RTCSessionDescription offer = await _peerConnection.createOffer({});
      await _peerConnection.setLocalDescription(offer);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String senderID = prefs.getString('_id')!;

      // Send the offer to the server
      final offerData = {
        'senderID': senderID, // Replace with actual sender ID
        'receiverID': receiverID, // Replace with actual receiver ID
        'offerSDP': offer.sdp,
      };

      final response = await http.post(
        Uri.parse('https://chat-backend-22si.onrender.com/offer'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(offerData),
      );

      print(response.body);

      if (response.statusCode == 201) {
        print('Offer created successfully');
        _offerCreated = true;
        offerID = jsonDecode(response.body)['offer']['_id'];
      } else {
        print('Failed to create offer: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating offer: $e');
    }
  }

  Future<void> _createLocalStream() async {
    try {
      _localStream = await navigator.mediaDevices
          .getUserMedia({'audio': true, 'video': true});
      await _localRenderer.initialize();
      setState(() {
        _localRenderer.srcObject = _localStream;
      });
    } catch (e) {
      print('Error initializing local stream: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _receiverID = widget.receiverID;
    const aspectRatio = 1.0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: Colors.black.withOpacity(0.1),
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.participantName,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * aspectRatio,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: _remoteStream != null
                      ? RTCVideoView(
                          _remoteRenderer,
                          mirror: true,
                        )
                      : const Text(
                          "Remote stream not available"), // Placeholder for remote stream
                ),
                SizedBox(height: 1, child: Container(color: Colors.white)),
                SizedBox(
                  height: MediaQuery.of(context).size.width * aspectRatio,
                  child: _localStream != null
                      ? RTCVideoView(
                          _localRenderer,
                          mirror: true,
                        )
                      : const Text("Loading..."), // Add local renderer view
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
                      _isAudioOn ? _enableMicrophone() : _disableMicrophone();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(_isVideoOn ? Icons.videocam : Icons.videocam_off),
                  onPressed: () {
                    setState(() {
                      _isVideoOn = !_isVideoOn;
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
                _endCall(offerID);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
                  const Text('End Call', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _enableMicrophone() async {
    if (_localStream != null) {
      _localStream!.getAudioTracks().forEach((track) {
        track.enabled = true;
      });
    }
  }

  Future<void> _disableMicrophone() async {
    if (_localStream != null) {
      _localStream!.getAudioTracks().forEach((track) {
        track.enabled = false;
      });
    }
  }

  Future<void> _enableCamera() async {
    if (_localStream != null) {
      _localStream!.getVideoTracks().forEach((track) {
        track.enabled = true;
      });
    }
  }

  Future<void> _disableCamera() async {
    if (_localStream != null) {
      _localStream!.getVideoTracks().forEach((track) {
        track.enabled = false;
      });
    }
  }

  void _endCall(String offerID) {
    print("offerID is $offerID, HERE IT IS");
    _deleteOffer(offerID);
    _localStream?.dispose();
    Navigator.of(context).pop();
  }
}
