import 'package:flutter/material.dart';
import 'auth/LoginPage.dart';
import 'auth/SignupPage.dart';

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
        }
        return null;
      },
    );
  }
}



// https://elements.envato.com/login-ui-mobile-template-AUHZP85

