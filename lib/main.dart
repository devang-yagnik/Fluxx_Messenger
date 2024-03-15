import 'package:flutter/material.dart';
import 'package:fluxxmessanger/Pages/auth/loginpage.dart';
import 'package:fluxxmessanger/Pages/auth/signuppage.dart';
// Import Google Fonts package
import 'package:fluxxmessanger/Pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluxx Messenger',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 27,
            fontFamily: 'Pacifico', // Apply Pacifico font to the app bar title
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          toolbarHeight: 80, // Adjust the height as needed
        ),
        // Apply Pacifico font as the default font
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }

  Future<void> _checkRegistrationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool registered = prefs.getBool('isAuthenticated') ?? false;
    setState(() {
      isAuthenticated = registered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isAuthenticated ? const HomePage() : const SignUpPage();
  }
}
