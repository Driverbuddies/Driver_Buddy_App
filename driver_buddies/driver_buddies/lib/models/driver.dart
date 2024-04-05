import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
   String? id;
   String? name;
   String? email;
   String? dob;
   String? aadhar;
   String? dl;
   String? issueDate;
   String? expiryDate;
   String? referredBy;
   String? password;
   String? profileImageUrl;
   String? aadharFileUrl;
   String? dlFileUrl;
   String? googleId; // New field for Google Sign-In
   String? googleAccessToken; // New field for Google Sign-In
   String? googleIdToken; // New field for Google Sign-In
   String? phoneNumber;
   String? car_model;
   String? car_number;

  Driver({
    this.id,
    this.name,
    this.email,
    this.dob,
    this.aadhar,
    this.dl,
    this.issueDate,
    this.expiryDate,
    this.referredBy,
    this.password,
    this.profileImageUrl,
    this.aadharFileUrl,
    this.dlFileUrl,
    this.googleId,
    this.googleAccessToken,
    this.googleIdToken,
    this.phoneNumber,
    this.car_model ,
    this.car_number,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'dob': dob,
      'aadhar': aadhar,
      'dl': dl,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'referred_by': referredBy,
      'password': password,
      'profile_image_url': profileImageUrl,
      'aadhar_file_url': aadharFileUrl,
      'dl_file_url': dlFileUrl,
      'google_id': googleId,
      'google_access_token': googleAccessToken,
      'google_id_token': googleIdToken,
      'phone_number': phoneNumber,
      'car_model':car_model,
      'car_number': car_number,
    };
  }
}
