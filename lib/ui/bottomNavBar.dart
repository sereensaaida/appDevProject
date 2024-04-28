// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, size: 30,),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 30,),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout, size: 30,),
          label: 'Logout',
        ),

      ],
      selectedItemColor: Colors.pinkAccent[400],
      onTap: (int index) {
        if(index == 0) {
          Navigator.pushNamed(context, '/home');
        } else if (index == 1) {
          Navigator.pushNamed(context, 'profile');
        } else {
          // logout
          FirebaseAuth.instance.signOut();
          Navigator.pushNamed(context, '/login');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logged out successfully."))
          );
        }
      },
    );
  }
}
