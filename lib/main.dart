import 'package:eventmanager/friends/friendsPage.dart';
import 'package:flutter/material.dart';
import 'auth/LoginPage.dart';
import 'auth/SignupPage.dart';
import 'home/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Event Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      home: const LoginPage(),
      onGenerateRoute: (settings) {
        if(settings.name == "/login") {
          return MaterialPageRoute(builder: (context) => const LoginPage());
        } else if (settings.name == "/signup") {
          return MaterialPageRoute(builder: (context) => const SignupPage());
        } else if (settings.name == "/home") {
          return MaterialPageRoute(builder: (context) => const HomePage());
        } else if (settings.name == "/friends") {
          return MaterialPageRoute(builder: (context) => const FriendsPage());
        }
        return null;
      },
    );
  }
}




