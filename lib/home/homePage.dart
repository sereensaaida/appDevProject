import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                "Dashboard",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Home",
                style: TextStyle(color: Colors.grey[500], fontSize: 18),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.event,
                      size: 50,
                      color: Colors.pinkAccent[200],
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Create',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ))
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 50,
                      color: Colors.pinkAccent[200],
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Events',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ))
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.people_alt_sharp,
                      size: 50,
                      color: Colors.pinkAccent[200],
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/friends");
                        },
                        child: Text(
                          'Friends',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ))
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              'Upcoming events',
              style: TextStyle(fontSize: 25),
            ),
          ),
          // ListView.builder(
          //       itemCount: 3,
          //       itemBuilder: (context, index) {
          //         return ListTile(
          //           title: Text('test'),
          //         );
          //       }),

        ])));
  }
}
