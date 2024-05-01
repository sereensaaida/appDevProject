import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';
import 'event.dart';
import 'dart:convert';
import 'dart:io';



class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final Stream<QuerySnapshot> _EventStream =
  FirebaseFirestore.instance.collection('Events').snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('Events');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event List')),
      body: _events.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          Event event = _events[index];
          StreamBuilder<QuerySnapshot>(
              stream: _EventStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(' Something Went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    String docId = document.id;
                    return ListTile(
                      title: Text(data['name']),trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  String newName = '';
                                  return AlertDialog(
                                    title: Text('Edit User'),
                                    content: TextField(
                                      onChanged: (value) {
                                        newName = value;
                                      },
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            updateUser(docId, newName);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Update'))
                                    ],
                                  );
                                });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteUser(docId);
                          },
                        ),
                      ],
                    ),

                    );
                  }).toList(),
                );
              })
        },
      ),
    );
  }
}
