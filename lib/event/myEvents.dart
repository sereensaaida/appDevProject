import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';
import 'dart:convert';
import '../event/event.dart';
import 'dart:io';


class AllEventListPage extends StatefulWidget {
  const AllEventListPage({super.key});

  @override
  State<AllEventListPage> createState() => _AllEventListPageState();
}

class _AllEventListPageState extends State<AllEventListPage> {
  final Stream<QuerySnapshot> _eventStream =
  FirebaseFirestore.instance.collection('Events').snapshots();
  List? allEvents;


  CollectionReference eventCollection = FirebaseFirestore.instance.collection('Events');
  Future<void> fetchMyEvents() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('events')

            .get();

        setState(() {
          allEvents = querySnapshot.docs;
        });
      }
    } catch (e) {
      print("Error fetching events $e");
    }
  }

  void initState() {

    fetchMyEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Events'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 90, left: 10),
            height: 200,
            child: ListTile(
              leading: Image.network('https://i.ibb.co/TtNDYdY/Logo.jpg'),
              title: Text(
                "See all events and their information",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "View all events",
                style: TextStyle(color: Colors.grey[500], fontSize: 18),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10, left: 55, right: 55),
              child:
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: allEvents?.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                              "${allEvents?[index].get("name")}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [


                            ],
                          ),
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }
}








