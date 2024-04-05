import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHandler {
  Future<void> storeLocation(double latitude, double longitude) async {
    FirebaseFirestore.instance.collection('locations').add({
      'latitude': latitude,
      'longitude': longitude,
    });
  }
}
