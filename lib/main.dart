import 'dart:async';
import 'package:eventmanager/friends/friendsPage.dart';
import 'package:eventmanager/profile/profilePage.dart';
import 'package:flutter/material.dart';
import 'auth/LoginPage.dart';
import 'auth/SignupPage.dart';
import 'home/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyANQFUN_uMj6rU9iBPaOW7iBMUCYtffaqw",
      appId: '1:250486671587:android:83ea29269348eb94541dd6',
      messagingSenderId: '250486671587',
      projectId: 'eventmanager-57e84',
      storageBucket: 'eventmanager-57e84.appspot.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == "/login") {
          return MaterialPageRoute(builder: (context) => const LoginPage());
        } else if (settings.name == "/signup") {
          return MaterialPageRoute(builder: (context) => const SignupPage());
        } else if (settings.name == "/home") {
          return MaterialPageRoute(builder: (context) => const HomePage());
        } else if (settings.name == "/friends") {
          return MaterialPageRoute(builder: (context) => const FriendsPage());
        } else if (settings.name == "/profile") {
          return MaterialPageRoute(builder: (context) => const ProfilePage());
        }
        return null;
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://i.ibb.co/TtNDYdY/Logo.jpg'),
            SizedBox(height: 20),
            Text(
              'Welcome to your Event Manager!',
              style: TextStyle(fontSize: 24, color: Colors.pinkAccent),
            ),
            SizedBox(height: 10),
            Text(
              'Made by Sereen Saaida and Denis Voronov',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
