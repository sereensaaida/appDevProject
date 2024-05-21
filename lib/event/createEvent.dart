import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../ui/bottomNavBar.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  TextEditingController _budgetController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();


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

  Future<void> createEvent(BuildContext context) async {
    try {


      if (_nameController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _budgetController.text.isEmpty ||
          _locationController.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Empty field(s).")));
        return;
      }

      if(currentDate.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Date can't be older than today.")));
        return;
      }


        FirebaseAuth auth = FirebaseAuth.instance;
        User? user = auth.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('events')
              .add({
            'name': _nameController.text,
            'description': _descriptionController.text,
            'budget': _budgetController.text,
            'location': _locationController.text,
            'date': currentDate.toString().split(" ")[0],
            'guests': selectedFriends,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Event created successfully!")));
          Navigator.pushNamed(context, "/home");
      }

    } catch (e) {
      print(e);
    }
  }

  Future<void> _useCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Location services are disabled. Please enable them.")));
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Location permissions are denied.")));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Location permissions are permanently denied. We cannot request permissions.")));
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("Current position: ${position.latitude}, ${position.longitude}");

    // Reverse geocode to get address
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String address =
          "${placemark.street}, ${placemark.locality}, ${placemark.country}";
      _locationController.text = address;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to get address from coordinates.")));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        showSelected: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, left: 10),
            height: 150,
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
              padding: EdgeInsets.only(top: 20, left: 55, right: 55),
              child: TextField(
                controller: _nameController,
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
                  hintText: "Name",
                  contentPadding:
                  EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 12),
                ),
              )),
          Container(
              padding: EdgeInsets.only(top: 10, left: 55, right: 55),
              child: TextField(
                controller: _descriptionController,
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
                  hintText: "Description",
                  contentPadding:
                  EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 12),
                ),
              )),
          Container(
              padding: EdgeInsets.only(top: 10, left: 55, right: 55),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: _budgetController,
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
                  hintText: "Budget",
                  contentPadding:
                  EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 12),
                ),
              )),
          Container(
              padding: EdgeInsets.only(top: 20, left: 55, right: 55, bottom: 10),
              child: TypeAheadField(
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
              )),
          TextButton(
              onPressed: () {
                _useCurrentLocation();
              },
              child: Text('Use current location 📍',
                  style: TextStyle(fontSize: 16, color: Colors.grey))),
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
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                createEvent(context);
              },
              child: Text('Create Event',
                  style: TextStyle(fontSize: 20, color: Colors.white, letterSpacing: 0.5)))
        ],
      ),
    );
  }
}
