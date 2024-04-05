import 'dart:convert';
import 'package:fluxxmessanger/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signuppage.dart'; // Import the signuppage.dart file
// Import the homepage.dart file

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _passwordVisible = false;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _loginUser() async {
    final Uri registerUri =
        Uri.parse('https://chat-backend-22si.onrender.com/register');

    final userData = {
      'phone': _phoneController.text,
      'password': _passwordController.text,
      // Add other fields as needed
    };
    final jsonBody = jsonEncode(userData);
    print(jsonBody);
    try {
      final response = await http.post(
        registerUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final user = responseData['user'];
        // Handle successful registration
        // print(userData);
        print(user); // Print the registration status
        // Navigate to the home page after successful registration
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Save authentication flag to indicate user is authenticated
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('userName', user['username']!);
        await prefs.setString('phone', user['phone']!);
        await prefs.setString('_id', user['_id']!);
        if(user[''] != null){
          await prefs.setString('profilePhoto', user['profilePhoto']!);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
      } else {
        // Handle other status codes (e.g., 404, 500)
        print('Failed to register: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors
      print('Error registering user: $error');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 400,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF5800),
                      Color(0xFF0050FF),
                      Color(0xFFA400FF)
                    ],
                    stops: [0.2, 0.6, 0.8],
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
                      stops: [0, 0, 0.999],
                      begin: AlignmentDirectional(0, -1),
                      end: AlignmentDirectional(0, 1),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/fluxxlogo.png',
                            width: 100,
                            height: 66,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Text(
                        'Enter your details to Sign In',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(255, 87, 99, 108),
                        ),
                      ),
                      Container(
                        width: 100,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0x00FFFFFF),
                              Colors.white
                            ],
                            stops: [0, 0.1, 0.999],
                            begin: AlignmentDirectional(0, -1),
                            end: AlignmentDirectional(0, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _phoneController,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits long';
                      }
                      if (!value.contains(RegExp(r'^[0-9]+$'))) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                child: SizedBox(
                  width: 230,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform sign-in operation here
                      print('Sign in pressed');
                      // Navigate to the home page
                      _loginUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B39EF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
                    );
                  },
                  child: const Text(
                    'New User? Click here to Sign Up',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 87, 99, 108),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
