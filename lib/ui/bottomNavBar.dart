import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final bool showSelected;

  const BottomNavBar({super.key, required this.selectedIndex, required this.showSelected});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  void _onItemTapped(int index, BuildContext context) {
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/profile');
    } else {
      // logout
      FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, '/login');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Logged out successfully.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.dashboard,
            size: 30,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 30,
          ),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.logout,
            size: 30,
          ),
          label: 'Logout',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: widget.showSelected ? Colors.pinkAccent[400] : Color(0xFF000000).withOpacity(0.6),
      onTap: (index) {

        if (index == 0) {
          Navigator.pushNamed(context, '/home');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/profile');
        } else {
          // logout
          FirebaseAuth.instance.signOut();
          Navigator.pushNamed(context, '/login');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Logged out successfully.")));
        }
      },
    );
  }
}
