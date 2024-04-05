import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class UserModel extends Users {
  late String email;
  late String state;

  UserModel({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String city,
  }) : super(
    uid: uid,
    firstName: firstName,
    lastName: lastName,
    mobileNumber: mobileNumber,
    city: city,
  ) {
    this.email = email;

  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': mobileNumber,
      'city': city,
    };
  }
}



class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('users');  // Use DatabaseReference for Realtime Database
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return '+91$phoneNumber';
    } else {
      return phoneNumber;
    }
  }

  String? _selectedCity; // Use nullable types
  bool _isPhoneNumberValid = true; // Track phone number validity
  bool _isEmailValid = true; // Track email validity
  // List of available states

  List<String> _cities = [
    'Bhopal', 'Indore',
    'Jaipur', 'Udaipur', 'Jodhpur', 'Kota',
    'Vadodara', 'Rajkot', 'Surat', 'Ahmedabad',
    'Nagpur', 'Nashik', 'Aurangabad', 'Pune', 'Mumbai', 'Kolhapur',
    'Hyderabad',
    'Chennai', 'Coimbatore',
    'Vijayawada', 'Visakhapatnam',
    'Kochi',
    'Noida', 'Lucknow', 'Kanpur', 'Varanasi', 'Prayagraj', 'Agra', 'Ayodhya',
    'Shimla',
    'Chandigarh', 'Amritsar', 'Ludhiana',
    'Mysuru', 'Bangalore', 'Belgaum',
    'Dehradun', 'Haridwar',
    'Delhi',
    'Ranchi',
    'Siliguri', 'Kolkata',
    'Patna',
    'Goa',
    'Guwahati',
    'Imphal',
    'Raipur',
    'Gurugram',
  ];

  Future<void> _continue() async {
    try {
      // Validate all fields
      if (!_validateFields()) {
        return;
      }

      // Format the mobile number
      String formattedPhoneNumber = formatPhoneNumber(_mobileNumberController.text.trim());

      // Store user data in Firestore
      final user = FirebaseAuth.instance.currentUser;
      await _database.child(user!.uid).set(
        UserModel(
          uid: user?.uid ?? '',
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          mobileNumber: formattedPhoneNumber,

          city: _selectedCity ?? '',
        ).toMap(),
      );



      // Show success message using SnackBar
      _showSnackBar('Signed up successfully.');

      // Navigate to the next screen or perform additional actions
    } catch (e) {
      print("Error during registration: $e");
    }
  }

  bool _validateFields() {
    // Validate each field and show error messages if necessary
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _mobileNumberController.text.trim().isEmpty ||
        _selectedCity!.isEmpty) {  // Null check for _selectedCity
      _showSnackBar('Please fill in all fields.');
      return false;
    }

    bool isEmailValid = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(_emailController.text.trim());
    setState(() {
      _isEmailValid = isEmailValid;
    });

    if (!isEmailValid) {
      _showSnackBar('Please enter a valid email address.');
      return false;
    }

    // Validate phone number
    bool isPhoneNumberValid = _mobileNumberController.text.trim().length == 10;
    setState(() {
      _isPhoneNumberValid = isPhoneNumberValid;
    });

    if (!isPhoneNumberValid) {
      _showSnackBar('Please enter a 10-digit mobile number.');
      return false;
    }

    return true;
  }

  // Method to show SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _mobileNumberController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'eg: XXXXXXXXXX',
                  errorText: _isPhoneNumberValid ? null : 'Please enter a 10-digit mobile number.',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _isEmailValid ? null : 'Please enter a valid email address.',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Dropdown for State

              Text('City'),
              DropdownButtonFormField<String>(
                value: 'Indore',
                items: _cities.map((cities) {
                  return DropdownMenuItem<String>(
                    value: cities,
                    child: Text(cities),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCity = value ?? '';
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _continue,
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
