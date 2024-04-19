import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
                    title: Text("Create an acount!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                    subtitle: Text("Join us now", style: TextStyle(color: Colors.grey[500], fontSize: 18),),
                  ),

                ),
                Container(
                  padding: EdgeInsets.only(top: 40, left: 35, right: 35),
                  child: TextField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      hintText: "Username",
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
                  padding: EdgeInsets.only(top: 100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    child: Container(
                      width: 280,
                      padding: EdgeInsets.symmetric(vertical: 15), // Adjust padding as needed
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
                      Text("Already have an account?", style: TextStyle(color: Colors.grey[500], fontSize: 15),),
                      TextButton(onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      }, child: Text('Sign in', style: TextStyle(color: Colors.black, fontSize: 15),))
                    ],
                  ),
                )
              ]
          )

      ),
    );
  }
}
