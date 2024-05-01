import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? userID;
  String eventName;
  String description;
  double budget;
  DateTime eventDate;
  int guests;

  Event({
    required this.userID,
    required this.eventName,
    required this.description,
    required this.budget,
    required this.eventDate,
    required this.guests,
  });

  final Stream<QuerySnapshot> _userStream =
  FirebaseFirestore.instance.collection('Events').snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('Events');




  Future<void> addEvent() {
    return users
        .add({
      'userID': userID,
      'name': eventName,
      'description': description,
      'budget': budget,
      'eventDate': eventDate,
      'guests':guests
    })
        .then((value) => print("Event added"))
        .catchError((error) => print("Failed to add Event"));
  }
}
