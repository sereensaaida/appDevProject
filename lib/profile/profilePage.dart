import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<ProfilePage> {
  bool profileExists = false;

  // text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<bool> checkProfileExists() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
            .collection('Profile')
            .doc(user.uid)
            .get();

        return profileSnapshot.exists;
      }

      return false;
    } catch (e) {
      print("Error checking profile existence: $e");
      return false;
    }
  }

  Future<void> setProfileData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        emailController.text = user.email!;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('profile')
            .get();

        profileExists = querySnapshot.docs.isNotEmpty;
        DocumentSnapshot profileSnapshot = querySnapshot.docs.first;

        if (profileExists) {
          firstNameController.text = profileSnapshot.get("firstName");
          lastNameController.text = profileSnapshot.get("lastName");
          phoneController.text = profileSnapshot.get('phone');
        }
      }
    } catch (e) {
      print('Error while fetching profile data');
    }
  }

  Future<void> saveProfile() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        if (firstNameController.text.isEmpty &&
            lastNameController.text.isEmpty &&
            phoneController.text.isEmpty &&
            oldPasswordController.text.isEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Empty fields.")));
          return;
        }

        // if user entered old password and it's at least 8 characters
        if (oldPasswordController.text.isNotEmpty &&
            !(oldPasswordController.text.length < 8)) {
          // check if old password is correct
          AuthCredential credential = EmailAuthProvider.credential(
              email: user.email!, password: oldPasswordController.text);

          try {
            await user.reauthenticateWithCredential(credential);
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Invalid old password.")));
            return;
          }
          // check if new password is as least 8 characters and confirm == newPass
          if (!(newPasswordController.text.length < 8) &&
              newPasswordController.text == confirmPasswordController.text) {
            await user.updatePassword(newPasswordController.text);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Passwords don't match.")));
            return;
          }
        }

        // TODO: CHECK IF VALID PHONE NUMBER

        if (profileExists) {

          CollectionReference profilesRef = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('profile');

          QuerySnapshot profileSnapshot = await profilesRef.limit(1).get();

          String profileDocId = profileSnapshot.docs.first.id;

          await profilesRef.doc(profileDocId).update({
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'phone': phoneController.text
          });

          // update other fields
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('profile')
              .add({
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'phone': phoneController.text
          });
        }
        setProfileData();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update successful.")));
    } catch (e) {
      print(e);
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    setProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(
          selectedIndex: 1,
          showSelected: true,
        ),
        resizeToAvoidBottomInset: false,
        body: (Column(children: [
          Container(
            margin: EdgeInsets.only(top: 50, left: 10, bottom: 0),
            padding: EdgeInsets.zero,
            // height: 200,
            child: ListTile(
              leading: Image.network('https://i.ibb.co/TtNDYdY/Logo.jpg'),
              title: Text(
                "Profile",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Enter your information",
                style: TextStyle(color: Colors.grey[500], fontSize: 18),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 35, right: 35),
            child: TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[500]),
                hintText: "First name",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 28, left: 35, right: 35),
            child: TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[500]),
                hintText: "Last name",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 28, left: 35, right: 35),
            child: TextField(
              readOnly: true,
              style: TextStyle(color: Colors.grey[500]),
              controller: emailController,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[500]),
                hintText: "Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 28, left: 35, right: 35),
            child: TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[500]),
                hintText: "Phone",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 28, left: 35, right: 35),
            child: TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[500]),
                hintText: "Old password",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 28, left: 35, right: 35),
            child: TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[500]),
                hintText: "New password",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 28, left: 35, right: 35),
            child: TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[500]),
                hintText: "Confirm password",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
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
                  saveProfile();
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.grey[500]),
                )),
          ),
        ])));
  }
}
