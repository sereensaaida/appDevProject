import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final Stream<QuerySnapshot> _userStream =
  FirebaseFirestore.instance.collection('Events').snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('Events');


  Future<void> addEvent() {
    return users
        .add({
      'name': name,
    })
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add the user"));
  }


  int numberOfGuests = 0;

  void incrementGuests() {
    setState(() {
      numberOfGuests++;
    });
  }

  void decrementGuests() {
    setState(() {
      if (numberOfGuests > 0) {
        numberOfGuests--;
      }
    });
  }

  DateTime currentDate = DateTime.now();
  Future<void> _selectTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.pink,
              backgroundColor: Colors.white,

            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 90, left: 10),
            height: 200,
            child: ListTile(
              leading: Image.network('https://i.ibb.co/TtNDYdY/Logo.jpg'),
              title: Text(
                "Create Event",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Create new event",
                style: TextStyle(color: Colors.grey[500], fontSize: 18),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10, left: 55, right: 55),
              child: TextField(

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  hintText: "Enter your event name",
                  contentPadding: EdgeInsets.only(
                      top: 12, left: 8, right: 8, bottom: 12),
                ),
              )),
          Container(
              padding: EdgeInsets.only(top: 10, left: 55, right: 55),
          child: TextField(

            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintStyle: TextStyle(color: Colors.grey[500]),
              hintText: "Enter Description",
              contentPadding: EdgeInsets.only(
                  top: 12, left: 8, right: 8, bottom: 12),
            ),
          )),
          Container(
              padding: EdgeInsets.only(top: 10, left: 55, right: 55),
              child: TextField(

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  hintText: "Enter Budget",
                  contentPadding: EdgeInsets.only(
                      top: 12, left: 8, right: 8, bottom: 12),
                ),
              )),
          ListTile(
            contentPadding: EdgeInsets.only(top: 10, left: 55, right: 55),

            title: Text('Event Date: ' + currentDate.toString(),  style: TextStyle(color: Colors.grey[500])),

            trailing: Padding(

              padding: EdgeInsets.only(right: 10),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(style: ElevatedButton.styleFrom(
    backgroundColor: Colors.pinkAccent[400],
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
    ),
    ),
                      onPressed: () => _selectTime(context),
                      child: Text('Pick a Date', style: TextStyle(color: Colors.white)))
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(top: 10, left: 55, right: 55),

            title: Text('Amount Of Guests: $numberOfGuests',  style: TextStyle(color: Colors.grey[500])),

            trailing: Padding(

              padding: EdgeInsets.only(right: 10),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, color: Colors.pinkAccent[400]),
                    onPressed: decrementGuests,
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.pinkAccent[400]),
                    onPressed: incrementGuests,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(top: 10, left: 55, right: 55),
            title: Text("Items Needed:",  style: TextStyle(color: Colors.grey[500])),

            trailing: ElevatedButton(  style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
                onPressed: () {
                  //logic to add friend
                },
                child: Text('Your Items', style: TextStyle(color:  Colors.white))),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(top: 10, left: 55, right: 55),
            title: Text("Manage The Event With Others: ",  style: TextStyle(color: Colors.grey[500])),

            trailing: ElevatedButton(  style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
                onPressed: () {
                  //logic to add friend
                },
                child: Text('Add A Friend', style: TextStyle(color:  Colors.white))),
          ),
          ElevatedButton(  style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
              onPressed: () {
                //logic to add friend
              },
              child: Text('Create Event!', style: TextStyle(fontSize: 20, color: Colors.white)))





        ],
      ),
    );
  }
}




