import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:async/async.dart';
import '../event/event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';
class ViewEventsPage extends StatefulWidget {
  const ViewEventsPage({Key? key}) : super(key: key);

  @override
  _ViewEventsPageState createState() => _ViewEventsPageState();
}

class _ViewEventsPageState extends State<ViewEventsPage> {
  late Stream<List<DocumentSnapshot>> _myEventsStream;
  late Stream<List<DocumentSnapshot>> _myInvitesStream;

  @override
  void initState() {
    super.initState();
    _myEventsStream = _fetchEvents();
    _myInvitesStream = _fetchInviteEvents();
  }



  Stream<List<DocumentSnapshot>> _fetchEvents() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      final CollectionReference userEventsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('events');

      return userEventsCollection.snapshots().map((snapshot) => snapshot.docs);
    } else {
      throw Exception('User not logged in.');
    }
  }
  bool _isInviteEventsFetched = false;


  Stream<List<DocumentSnapshot>> _fetchInviteEvents() async* {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (!_isInviteEventsFetched) {
      _isInviteEventsFetched = true;
    if (user != null) {
      final CollectionReference usersCollection = FirebaseFirestore.instance
          .collection('users');
      final QuerySnapshot usersSnapshot = await usersCollection.get();
      List<Stream<List<DocumentSnapshot>>> streams = [];

      for (var userDoc in usersSnapshot.docs) {
        final CollectionReference userEventsCollection = usersCollection.doc(
            userDoc.id).collection('events');

        streams.add(
          userEventsCollection.where('guests', arrayContains: user.uid)
              .snapshots()
              .map((snapshot) {
            return snapshot.docs;
          }),
        );
      }

      await for (var value in StreamGroup.merge(streams)) {
        if (value.isNotEmpty) {
          yield value;
        }
      }
    }
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Events'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.event, color: Colors.pinkAccent),
                text: 'My Events',
              ),
              Tab(
                icon: Icon(Icons.people, color: Colors.pinkAccent),
                text: 'My Invites',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventsTab(_myEventsStream),
            _buildInviteEventsTab(() => _fetchInviteEvents()),
          ],
        ),
      ),
    );
  }
  Widget _buildEventsTab(Stream<List<DocumentSnapshot>> stream) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final events = snapshot.data ?? [];
        if (events.isEmpty) {
          return Center(child: Text('No events available'));
        }
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = events[index];
            Map<String, dynamic> eventData = document.data() as Map<String, dynamic>;
            String eventId = document.id;

            eventData['id'] = eventId;
            return Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.pinkAccent, width: 2.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventData['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.pinkAccent),
                          SizedBox(width: 5),
                          Text(
                            eventData['date'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.pinkAccent),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              eventData['location'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EventDetailsPage(eventData: eventData, status: 1),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInviteEventsTab(Stream<List<DocumentSnapshot>> Function() streamBuilder ) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: streamBuilder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final events = snapshot.data ?? [];
        if (events.isEmpty) {
          return Center(child: Text('No events available'));
        }
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = events[index];
            Map<String, dynamic> eventData = document.data() as Map<String, dynamic>;
            String eventId = document.id;

            eventData['id'] = eventId;
            return Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.pinkAccent, width: 2.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventData['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.pinkAccent),
                          SizedBox(width: 5),
                          Text(
                            eventData['date'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.pinkAccent),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              eventData['location'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EventDetailsPage(eventData: eventData, status: 2),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}


class EventDetailsPage extends StatelessWidget {
  final Map<String, dynamic> eventData;
  final int status;

  const EventDetailsPage({Key? key, required this.eventData, required this.status}) : super(key: key);

  Future<String> fetchUserEmail(String userId) async {
    final userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userData['email'];
  }

  Future<void> deleteEvent(BuildContext context, String eventId) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('events')
            .doc(eventId)
            .delete();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Event Deleted"),
              content: Text("The event has been successfully deleted."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                  },
                ),
              ],
            );
          },
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error deleting event"),
              content: Text("An error occurred while deleting the event: $error"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        showSelected: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
        children:[ Container(
    padding: EdgeInsets.only(top: 50, left: 10),
    height: 150,
    child: ListTile(
    leading: Image.network('https://i.ibb.co/TtNDYdY/Logo.jpg'),
    title: Text(
    "Events viewing",
    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
    "View  ${eventData['name']}",
    style: TextStyle(color: Colors.grey[500], fontSize: 18),
    ),
    ),
    ),
    Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.pinkAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event, size: 36, color: Colors.pinkAccent),
                  SizedBox(width: 10),
                  Text(
                    eventData['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description, size: 36, color: Colors.pinkAccent),
                  SizedBox(width: 10),
                  Text(
                    'Description: ${eventData['description']}',
                    style: TextStyle(fontSize: 18, color: Colors.pinkAccent),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.attach_money, size: 36, color: Colors.pinkAccent),
                  SizedBox(width: 10),
                  Text(
                    'Budget: ${eventData['budget']}',
                    style: TextStyle(fontSize: 18, color: Colors.pinkAccent),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, size: 36, color: Colors.pinkAccent),
                  SizedBox(width: 10),
                  Text(
                    'Location: ',
                    style: TextStyle(fontSize: 18, color: Colors.pinkAccent),
                  ),
                  Text(
                    '${eventData['location']}',
                    style: TextStyle(fontSize: 12, color: Colors.pinkAccent),

                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  if (eventData['guests'] != null && eventData['guests'].isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people, size: 36, color: Colors.pinkAccent),
                            SizedBox(width: 10),
                            FutureBuilder(

                              future: fetchUserEmail(eventData['guests'][0]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text('Loading...');
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final guestEmail = snapshot.data.toString();
                                  return Text(
                                    'Guests: $guestEmail', // Show guest email
                                    style: TextStyle(fontSize: 18, color: Colors.pinkAccent),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 36, color: Colors.pinkAccent),
                  SizedBox(width: 10),
                  Text(
                    'Date: ${eventData['date']}',
                    style: TextStyle(fontSize: 18, color: Colors.pinkAccent),
                  ),
                ],
              ),
              SizedBox(height: 20),
      ListTile(
        leading: status == 1
            ? ElevatedButton(
          onPressed: () {
            deleteEvent(context, eventData['id']);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.pinkAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text('Delete'),
        )
            : null,
        trailing: status == 1
            ? ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditEventPage(eventData: eventData),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.pinkAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text('Edit'),
        )
            : null,
      ),

            ],
          ),
        ),
      ]),
      ));
  }
}


class EditEventPage extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EditEventPage({Key? key, required this.eventData}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}



class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _budgetController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.eventData['name']);
    _descriptionController = TextEditingController(text: widget.eventData['description']);
    _budgetController = TextEditingController(text: widget.eventData['budget']);
    fetchFriends();
    _locationController = TextEditingController(text: widget.eventData['location']);
    currentDate = DateTime.parse(widget.eventData['date']);
    _dateController = TextEditingController(text: widget.eventData['date']);

  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  DateTime currentDate = DateTime.now();

  Future<List<String>> _fetchLocations(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.geoapify.com/v1/geocode/autocomplete?text=$query&apiKey=64e26f926c7f4a18b39b30330b9fb634'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final features = data['features'] as List;
      return features.map((feature) => feature['properties']['formatted'] as String).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

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

  List friends = [];
  List<String> selectedFriends = [];
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
  void _showSelectFriendsPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Friends'),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return StatefulBuilder(
                  builder: (context, setState) {
                    final isSelected = selectedFriends.contains(friend.id);
                    return ListTile(
                      title: Text(friend.get("email")),
                      trailing: isSelected ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedFriends.remove(friend.id);
                          } else {
                            selectedFriends.add(friend.id);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                print('Selected friends: $selectedFriends');
                Navigator.of(context).pop();
              },
              child: Text('Select'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateEvent(BuildContext context, String eventId, String newName, String newDescription, String newBudget, String newLocation, String newDate) async {
    User? user = FirebaseAuth.instance.currentUser;

    if(currentDate.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Date can't be older than today.")));
      return;
    }

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('events')
            .doc(eventId)
            .update({
          'name': newName,
          'description': newDescription,
          'budget': newBudget,
          'location': newLocation,
        'date': currentDate.toString().split(" ")[0],

        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Event Updated"),
              content: Text("The event has been successfully updated."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                  },
                ),
              ],
            );
          },
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Update failed"),
              content: Text("Error updating the event: $error"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("User not found"),
            content: Text("The user associated with the id has not been found"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        showSelected: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, left: 10),
                height: 150,
                child: ListTile(
                  leading: Image.network('https://i.ibb.co/TtNDYdY/Logo.jpg'),
                  title: Text(
                    "Edit Event",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Edit existing event",
                    style: TextStyle(color: Colors.grey[500], fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: _budgetController,
                decoration: InputDecoration(
                  labelText: 'Budget',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TypeAheadField(
                controller: _locationController,
                builder: (context, controller, focusNode) {
                  return TextField(
                      controller: _locationController,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location',
                      )
                  );
                },
                suggestionsCallback: (pattern) async {
                  return await _fetchLocations(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSelected: (String suggestion) {
                  _locationController.text = suggestion;
                },
              ),
              SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.only(top: 15, left: 55, right: 55),
            title: Text('Event Date: ' + currentDate.toString().split(" ")[0],
                style: TextStyle(color: Colors.grey[500])),
            trailing: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: () => _selectTime(context),
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.grey,
                        size: 30,
                      )),
                ],
              ),
            ),
          ),
              SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.only(top: 10, left: 55, right: 55),
                title:
                Text("Guest list: ", style: TextStyle(color: Colors.grey[500])),
                trailing: TextButton(
                    onPressed: () {
                      _showSelectFriendsPopup();
                    },
                    child: Text('Select friends 🤝🏼',
                        style: TextStyle(color: Colors.grey, fontSize: 16))),
              ),
              SizedBox(height:20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                onPressed: () {
                  if (_nameController.text.isEmpty ||
                      _descriptionController.text.isEmpty ||
                      _budgetController.text.isEmpty ||
                      _locationController.text.isEmpty ||
                      _dateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill in all fields.'),
                      ),
                    );
                  } else {
                    updateEvent(
                      context,
                      widget.eventData['id'],
                      _nameController.text,
                      _descriptionController.text,
                      _budgetController.text,
                      _locationController.text,
                      _dateController.text,
                    );
                  }
                },
                child: Text('Update Event',   style: TextStyle(fontSize: 20, color: Colors.white, letterSpacing: 0.5))
                ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


