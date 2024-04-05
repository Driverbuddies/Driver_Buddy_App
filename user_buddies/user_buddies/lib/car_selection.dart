import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarSelectionPage extends StatefulWidget {
  @override
  _CarSelectionPageState createState() => _CarSelectionPageState();
}

class _CarSelectionPageState extends State<CarSelectionPage> {
  String selectedCarType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Selection'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectCar('Automated'),
              child: Text('Automated'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectCar('Manual'),
              child: Text('Manual'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectCar('Luxury'),
              child: Text('Luxury'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectCar(String carType) {
    setState(() {
      selectedCarType = carType;
    });

    // Store the selected car type in Firebase
    _storeSelectedCarType(carType);
  }

  Future<void> _storeSelectedCarType(String carType) async {
    try {
      // Get the current user's UID (you need to implement Firebase authentication)
      String userUid = 'user_uid'; // Replace with your authentication logic

      await FirebaseFirestore.instance
          .collection('user_car_selection')
          .doc(userUid)
          .set({
        'selectedCarType': carType,
      });

      print('Car type stored successfully: $carType');
    } catch (e) {
      print('Error storing car type: $e');
    }
  }
}
