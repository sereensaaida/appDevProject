import 'package:eventmanager/friends/friendsPage.dart';
import 'package:eventmanager/profile/profilePage.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth/LoginPage.dart';
import 'auth/SignupPage.dart';
import 'home/homePage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyANQFUN_uMj6rU9iBPaOW7iBMUCYtffaqw",
    appId: '1:250486671587:android:83ea29269348eb94541dd6',
    messagingSenderId: '250486671587',
    projectId: 'eventmanager-57e84',
    storageBucket: 'eventmanager-57e84.appspot.com',
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      // home: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, AsyncSnapshot<User?> snapshot) {
      //     if(snapshot.hasData && snapshot.data != null) {
      //       return HomePage();
      //     } else if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     return LoginPage();
      //   }
      // ),

      home: LoginPage(),
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
