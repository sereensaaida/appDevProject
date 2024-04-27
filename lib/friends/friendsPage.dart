import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(),
        resizeToAvoidBottomInset: false,
        body: (Column(children: [
          Container(
            padding: EdgeInsets.only(top: 90, left: 10),
            height: 200,
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
            padding: EdgeInsets.only(top: 30, left: 35, right: 35),
            child: Text(
              'Send a friend request', style: TextStyle(fontSize: 25),),
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
                      hintText: "Enter username",
                      contentPadding: EdgeInsets.only(
                          top: 12, left: 8, right: 8, bottom: 12),
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.grey),
                      // ),
                      // focusedBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.grey),
                      // ),
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
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                  child: Text('Send', style: TextStyle(color: Colors.white),),
                ),

              ],

            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, left: 35, right: 35),
            child: Text('Friends', style: TextStyle(fontSize: 25),),
          ),



        ])));
  }
}
