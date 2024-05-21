import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../ui/bottomNavBar.dart';


class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(selectedIndex: 0, showSelected: true),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, left: 10),
              height: 150,
              child: ListTile(
                leading: Image.network('https://i.ibb.co/TtNDYdY/Logo.jpg'),
                title: Text(
                  "About us",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Learn more about both our developers!",
                  style: TextStyle(color: Colors.grey[500], fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 36, color: Colors.pinkAccent),
                  SizedBox(height: 10),
                  Text(
                    'Our Story',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Our team is composed of two driven developers (one better than the other) who seek a career in the fast-growing computer science field',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.military_tech, size: 36, color: Colors.pinkAccent),
                  SizedBox(height: 10),
                  Text(
                    'Our Mission',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'We made this applcation to serve as guidance and encourage organization when planning an event',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.contact_mail, size: 36, color: Colors.pinkAccent),
                  SizedBox(height: 10),
                  Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Address:',
                    style: TextStyle(fontSize: 16, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '123 vanier college',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone:',
                    style: TextStyle(fontSize: 16, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '5141111111',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email:',
                    style: TextStyle(fontSize: 16, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'sereen@test.com',
                    style: TextStyle(fontSize: 16),
                  ),Text(
                    'denis@test.com',
                    style: TextStyle(fontSize: 16),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
