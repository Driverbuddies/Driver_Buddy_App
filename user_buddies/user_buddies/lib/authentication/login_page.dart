import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_verification_page.dart';
import 'signup_page.dart';
import 'package:firebase_database/firebase_database.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _mobileNumberController = TextEditingController();
  String? mobileNumber;
  // Define the formatPhoneNumber function within the _LoginPageState class
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return '+91$phoneNumber';
    } else {
      return phoneNumber;
    }
  }
  Future<void> _loginWithOTP() async {
    try {
      // Format the mobile number
      String formattedPhoneNumber = formatPhoneNumber(_mobileNumberController.text.trim());

      // Check if the mobile number is registered in the 'users' node in the Realtime Database
      DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('users');
      DatabaseEvent snapshot = await usersRef.orderByChild('mobileNumber').equalTo(formattedPhoneNumber).once();

      if (snapshot.snapshot.value != null) {

        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: formattedPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // ... rest of the code
          },
          verificationFailed: (FirebaseAuthException e) {
            print('Error during phone verification: $e');
            // Handle verification failure
          },
          codeSent: (String verificationId, int? resendToken) async {
            // You can implement code to handle when the verification code is sent
            // Navigate to OTP verification screen and pass verificationId
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationPage(
                  verificationId: verificationId,
                  phoneNumber: formattedPhoneNumber,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) async {
            // You can implement code to handle when code auto-retrieval times out
          },
        );
      } else {
        // If the phone number is not registered, show an error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("User not found"),
              content: const Text(
                  "User does not exist. Please sign up with this mobile number."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error during phone number login: $e');
      // Handle phone number login failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Phone Number Login Error"),
            content: const Text("Invalid phone number. Please try again."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DRIVER BUDDIES',
          style: TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'YourPreferredFont',  // Replace with your preferred font
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/car_background.jpg'),  // Replace with your car image asset
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: _mobileNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: ' Mobile Number',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: Icon(Icons.phone, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loginWithOTP,
                  child: Text('Login with OTP'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: Text('Don\'t have an account? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }}
