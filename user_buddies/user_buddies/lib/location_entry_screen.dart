// location_entry_screen.dart

import 'package:flutter/material.dart';
import 'location_data.dart';

class LocationEntryScreen extends StatefulWidget {
  @override
  _LocationEntryScreenState createState() => _LocationEntryScreenState();
}

class _LocationEntryScreenState extends State<LocationEntryScreen> {
  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: currentLocationController,
              decoration: InputDecoration(labelText: 'Current Location'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final locationData = UserBuddiesLocationData(
                  currentLocation: currentLocationController.text,
                  destination: destinationController.text,
                );

                Navigator.pop(context, locationData);
              },
              child: Text('Save Location'),
            ),
          ],
        ),
      ),
    );
  }
}
