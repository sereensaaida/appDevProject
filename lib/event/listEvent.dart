import 'package:flutter/material.dart';
import '../main.dart';
import '../ui/bottomNavBar.dart';
import 'dart:convert';
import '../event/event.dart';
import 'dart:io';

class EventListPage extends StatelessWidget {
  final List<Event> events;

  EventListPage({required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.eventName),
            subtitle: Text('Date: ${event.eventDate} | Guests: ${event.guests}'),
            // Add more details or actions as needed
          );
        },
      ),
    );
  }
}

