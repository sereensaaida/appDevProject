import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendRequestsPage> {
  TextEditingController emailController = TextEditingController();
  List? friendRequests;

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

  Future<void> sendFriendRequest(context) async {
    try {

      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {

        if(user.email == emailController.text) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
              Text("Can't send a friend request to yourself.")));
          emailController.text = "";
          return;
        }

        // check if users are already friends:


        QuerySnapshot recipientQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: emailController.text)
            .limit(1)
            .get();

        if (recipientQuery.docs.isNotEmpty) {
          String recipientUid = recipientQuery.docs.first.id;

          // check if users are already friends
          DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('friends')
              .doc(recipientUid)
              .get();

          if(friendSnapshot.exists) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                Text("You are already friends with this user.")));
            emailController.text = "";
            return;
          }

          DocumentSnapshot requestSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(recipientUid)
              .collection('friend_requests')
              .doc(user.uid)
              .get();

          if (requestSnapshot.exists) {
            print('Friend request already sent to this user');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("You already sent a friend request to this user.")));
            emailController.text = "";
            return;
          }

          // Add a document to the recipient's 'friend_requests' subcollection
          await FirebaseFirestore.instance
              .collection('users')
              .doc(recipientUid)
              .collection('friend_requests')
              .doc(user.uid)
              .set({
            'email': user.email,
          });
        }
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Friend request sent.")));
      emailController.text = "";
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong.")));
    }
  }

  Future<void> fetchFriendRequests() async {
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
          friendRequests = querySnapshot.docs;
        });
      }
    } catch (e) {
      print("Error fetching friend requests: $e");
    }
  }

  Future<void> acceptFriendRequest(String senderUID) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        DocumentSnapshot requestSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('friend_requests')
            .doc(senderUID)
            .get();

        if (requestSnapshot.exists) {
          String senderEmail = requestSnapshot.get('email');

          // Add friend to 'friends' subcollection
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('friends')
              .doc(senderUID)
              .set({
            'email': senderEmail,
          });

          // add friend to 'friends' subcollection of other user
          await FirebaseFirestore.instance
              .collection('users')
              .doc(senderUID)
              .collection('friends')
              .doc(user.uid)
              .set({
            'email': user.email,
          });

          // Delete friend request
          await deleteFriendRequest(senderUID);
        }
      }
    } catch (e) {
      print("Error accepting friend request: $e");
    }
  }

  Future<void> deleteFriendRequest(String requestId) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        // Delete friend request
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('friend_requests')
            .doc(requestId)
            .delete();
      }
      fetchFriendRequests();
    } catch (e) {
      print("Error deleting friend request: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchFriendRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(selectedIndex: 0, showSelected: false,),
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
            padding: EdgeInsets.only(top: 15, left: 35, right: 35),
            child: Text(
              'Send a friend request',
              style: TextStyle(fontSize: 25),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, left: 35, right: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  // padding: EdgeInsets.only(top: 30, left: 35, right: 35),
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
                    }
                    else {
                      sendFriendRequest(context);
                    }
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, left: 35, right: 35),
            child: Text(
              'Received requests',
              style: TextStyle(fontSize: 25),
            ),
          ),
          Expanded(
            child: friendRequests == null
                ? Center(child: CircularProgressIndicator())
                : (friendRequests?.length == 0)
                    ? Center(
                        child: Text(
                          "No friend requests",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: friendRequests?.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Divider(),
                              ListTile(
                                title: Text(
                                    "${friendRequests?[index].get("email")}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        acceptFriendRequest(
                                            friendRequests?[index].id);

                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        deleteFriendRequest(
                                            friendRequests?[index].id);

                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
          )
        ])));
  }
}
