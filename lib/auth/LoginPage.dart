import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: emailController.text, password: passController.text);
      Navigator.pushNamed(context, "/home");
    } catch (e) {
      print('Failed to sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid credentials.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // avoid "bottom overflowed by..." when opening keyboard
      resizeToAvoidBottomInset : false,
      body: (
          Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 90, left: 10),
                  height: 200,
                  child: ListTile(
                    leading: Image.network('https://i.ibb.co/TtNDYdY/Logo.jpg'),
                    title: Text("Welcome!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                    subtitle: Text("Sign in to continue", style: TextStyle(color: Colors.grey[500], fontSize: 18),),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80, left: 35, right: 35),
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
                  // 157, buttons on login and signup on the location
                  padding: EdgeInsets.only(top: 157),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      if(emailController.text.isEmpty || passController.text.isEmpty || passController.text.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Invalid credentials.")));
                      } else {
                        login(context);
                      }
                      // Add your onPressed logic here
                    },
                    child: Container(
                      width: 280,
                      padding: EdgeInsets.symmetric(vertical: 15), // Adjust padding as needed
                      alignment: Alignment.center,
                      child: Text(
                        'SIGN IN',
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
                      Text("Don't have an account?", style: TextStyle(color: Colors.grey[500], fontSize: 15),),
                      TextButton(onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      }, child: Text('Sign up', style: TextStyle(color: Colors.black, fontSize: 15),))
                    ],
                  ),
                ),
              ]
          )

      ),
    );
  }
}

