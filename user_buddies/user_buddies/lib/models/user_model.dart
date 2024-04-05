import 'package:firebase_database/firebase_database.dart';

class Users {
  String? uid;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? city;

  Users({
    this.uid,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.city,
  });

  // Factory constructor to create a User instance from a DataSnapshot
  factory Users.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?;

    return Users(
      uid: snapshot.key ?? '',
      firstName: data?['firstName'] ?? '',
      lastName: data?['lastName'] ?? '',
      mobileNumber: data?['mobileNumber'] ?? '',
      city: data?['city'] ?? '',
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'city': city,
    };
  }
}
