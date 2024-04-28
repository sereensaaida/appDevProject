
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('Users').snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  // Future<void> addUser(context) {
  //   return users
  //       .add({'email': emailController.text, 'password': passController.text})
  //       .then((value) => Navigator.pushNamed(context, "/home"))
  //       .catchError((error) => {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text("Email already exists.")))
  //           });
  // }

  Future<void> addUser(context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text,
        'firstName': "",
        'lastName': "",
      });
      // User successfully created
      User? user = userCredential.user;
      Navigator.pushNamed(context, "/home");
    } catch (e) {
      // An error occurred
      print('Failed to create user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Email already exists.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // avoid "bottom overflowed by..." when opening keyboard
      resizeToAvoidBottomInset: false,
      body: (Column(children: [
        Container(
          padding: EdgeInsets.only(top: 90, left: 10),
          height: 200,
          child: ListTile(
            leading: Image.network('https://i.ibb.co/TtNDYdY/Logo.jpg'),
            title: Text(
              "Create account",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Join us now!",
              style: TextStyle(color: Colors.grey[500], fontSize: 18),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 40, left: 35, right: 35),
          child: TextField(
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
          padding: EdgeInsets.only(top: 50, left: 35, right: 35),
          child: TextField(
            controller: passController,
            obscureText: true,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey[500]),
              hintText: "Password",
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
          padding: EdgeInsets.only(top: 50, left: 35, right: 35),
          child: TextField(
            controller: confirmPassController,
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
        Container(
          padding: EdgeInsets.only(top: 100),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              // if email valid
              if (emailController.text.isEmpty || passController.text.isEmpty) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Empty field(s).")));
              } else if (!EmailValidator.validate(emailController.text)) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Invalid email.")));
              } else if (passController.text.length < 8) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Password must be at least 8 characters.")));
              } else if (passController.text != confirmPassController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Passwords must match.")));
              } else {
                addUser(context);

                // currently signed in user
              }
              // Add your onPressed logic here
            },
            child: Container(
              width: 280,
              padding: EdgeInsets.symmetric(vertical: 15),
              // Adjust padding as needed
              alignment: Alignment.center,
              child: Text(
                'SIGN UP',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(color: Colors.grey[500], fontSize: 15),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ))
            ],
          ),
        )
      ])),
    );
  }
}
