import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';
import 'friendRequests.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  TextEditingController emailController = TextEditingController();
  List? friends;
  int? friendRequestsCount;

  Future<bool> checkEmailExists() async {
    try {
      FirebaseAuth.instance.currentUser!.getIdToken(true);
      List<String> signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(emailController.text);
      return signInMethods.isNotEmpty;
    } catch (e) {
      return false;
      // Handle the error, such as displaying an error message to the user
    }
  }

  Future<void> fetchFriendRequestsCount() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('friend_requests')
            .get();

        setState(() {
          friendRequestsCount = querySnapshot.size;
        });
      }
    } catch (e) {
      print("Error fetching friend requests count: $e");
    }
  }

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

  Future<void> deleteFriend(String friendUid) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        // delete friend from user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('friends')
            .doc(friendUid)
            .delete();

        // delete friend from other user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(friendUid)
            .collection('friends')
            .doc(user.uid)
            .delete();

        fetchFriends();
      }
    } catch (e) {
      print("Error deleting friend: $e");
    }
  }

  Future<void> searchFriendByEmail() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('friends')
            .where('email', isEqualTo: emailController.text)
            .get();

        setState(() {
          friends = querySnapshot.docs;
        });
      }
    } catch (e) {
      print("Error searching friends by email: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchFriends();
    fetchFriendRequestsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(),
        resizeToAvoidBottomInset: false,
        body: (Column(children: [
          Container(
            margin: EdgeInsets.only(top: 50, left: 10, bottom: 20),
            padding: EdgeInsets.zero,
            // height: 200,
            child: ListTile(
              leading: Image.network('https://i.ibb.co/TtNDYdY/Logo.jpg'),
              title: Text(
                "Friends",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Add or remove friends",
                style: TextStyle(color: Colors.grey[500], fontSize: 18),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 0, left: 35, right: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 200,
                  height: 50,
                  child: TextField(
                    controller: emailController,
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
                      hintText: "Enter email",
                      contentPadding: EdgeInsets.only(
                          top: 15, left: 8, right: 8, bottom: 15),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      if (!EmailValidator.validate(emailController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Invalid email.")));
                      } else if (!await checkEmailExists()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Email doesn't exist.")));
                      } else {
                        searchFriendByEmail();
                      }
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
          Container(
            width: 370,
            padding: EdgeInsets.only(top: 15, left: 35, right: 35),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendRequestsPage()));
              },
              child: Text(
                  'Friend requests (${friendRequestsCount == null ? "0" : friendRequestsCount})',
                  style: TextStyle(color: Colors.grey[600])),
            ),
          ),
          Expanded(
            child: friends == null
                ? Center(child: CircularProgressIndicator())
                : (friends?.length == 0)
                    ? Center(
                        child: Text(
                          "No friends",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: friends?.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Divider(),
                              ListTile(
                                title: Text("${friends?[index].get("email")}"),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    deleteFriend(friends?[index].id);
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
          ),
          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  fetchFriends();
                  emailController.text = "";
                },
                child: Text(
                  "Reset",
                  style: TextStyle(color: Colors.grey[500]),
                )),
          ),
          SizedBox(
            height: 20,
          )
        ])));
  }
}
