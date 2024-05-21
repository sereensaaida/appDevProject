import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';
import '../event/event.dart';
import '../event/singleEvent.dart';
import '../event/singleEvent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';


class EditEventPage extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EditEventPage({Key? key, required this.eventData}) : super(key: key);

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late Stream<List<DocumentSnapshot>> _eventsStream;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _budgetController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();
  late DateTime currentDate;
  late List<String> selectedFriends;
  List friends = [];

  Future<void> fetchFriends() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('friends')
            .get();

        setState(() {
          friends = querySnapshot.docs;
        });
      }
    } catch (e) {
      print("Error fetching friends: $e");
    }
  }


  @override
  void initState() {
    super.initState();
    _eventsStream = _fetchEvents();
    _initializeData();
    fetchFriends();
  }

  void _initializeData() {
    _nameController.text = widget.eventData['name'];
    _descriptionController.text = widget.eventData['description'];
    _budgetController.text = widget.eventData['budget'];
    _locationController.text = widget.eventData['location'];
    currentDate = DateTime.parse(widget.eventData['date']);
    selectedFriends = List<String>.from(widget.eventData['guests']);
  }

  Stream<List<DocumentSnapshot>> _fetchEvents() {
    final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
    return usersCollection.snapshots().asyncMap((snapshot) async {
      List<DocumentSnapshot> events = [];
      for (final doc in snapshot.docs) {
        final eventsCollection = doc.reference.collection('events');
        final eventsQuery = await eventsCollection.get();
        events.addAll(eventsQuery.docs);
      }
      return events;
    });
  }

  Future<void> editEvent(BuildContext context) async {
    try {
      // Check for empty fields here if needed

      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('events')
            .doc(widget.eventData['id']) // Use the event's ID for editing
            .update({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'budget': _budgetController.text,
          'location': _locationController.text,
          'date': currentDate.toString().split(" ")[0],
          'guests': selectedFriends,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Event edited successfully!")));
        Navigator.pushNamed(context, "/home");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _budgetController,
              decoration: InputDecoration(labelText: 'Budget'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            // Other fields or widgets as needed
            ElevatedButton(
              onPressed: () {
                editEvent(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
