
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../mainScreens/main_screen.dart';
import 'firstpage.dart';
import 'profile.dart';
import '../models/user.dart';
import '../models/driver.dart';
import 'OTPVerificationPage.dart';

import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../google_signin_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Initializing Firebase...");
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBc-Uh6f8uA9Ag3BXQwdmmR2AkXCUYKAGo",
      appId: "1:706892114240:android:f99b17be66c0a03d7cf2a5",
      messagingSenderId: "706892114240",
      projectId: "new-firebase-setup-e0f49",
      storageBucket: "gs://new-firebase-setup-e0f49.appspot.com",
    ),
  );
  print("Firebase Initialized");

  runApp(MyApp(uniqueKey: 'yourUniqueKey'));
}
final FirebaseAuth _auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  final String uniqueKey;

  MyApp({required this.uniqueKey});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(uniqueKey: uniqueKey),
    );
  }
}
class LoginPage extends StatelessWidget {
  final String uniqueKey;
  late String profileImageUrl = 'assets/default_profile_image.jpg';
  late String formattedPhoneNumber = '';
  LoginPage({required this.uniqueKey});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final GoogleSignInController googleSignInController = Get.put(GoogleSignInController());


  Future<void> _login(BuildContext context) async {
    try {
      final String email = emailController.text;
      final String password = passwordController.text;

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final User user = userCredential.user!;

      // Check if the user exists in the drivers database
      final DatabaseEvent result = await FirebaseDatabase.instance
          .reference()
          .child('drivers')
          .orderByChild('email')
          .equalTo(email)
          .once();

      if (result.snapshot.value != null) {
        final userData = (result.snapshot.value as Map<dynamic, dynamic>?)?.values.first;

        final String fullName = userData['name'] as String? ?? 'Unknown';
        final String? profileImageUrl = userData['profile_image_url'] as String?;

        await FirebaseFirestore.instance
            .collection('loginuser')
            .doc(user.uid)
            .set(
          User1(
            id: user.uid,
            email: user.email!,
            fullName: fullName,
            profileImageUrl: profileImageUrl ?? 'default_image_url',
          ).toMap(),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      } else {
        // User does not exist in the drivers database
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("User not found"),
              content: const Text("User does not exist. Please sign up."),
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
      print('Error during login: $e');
      // Handle login failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Login Error"),
            content: const Text("Invalid email or password. Please try again."),
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

  Future<void> _handleUserData(BuildContext context, User? user) async {
    if (user != null) {
      try {
        final DatabaseEvent result = await FirebaseDatabase.instance
            .reference()
            .child('drivers')
            .orderByChild('phoneNumber')
            .equalTo(formattedPhoneNumber)
            .once();

        if (result.snapshot.value != null) {
          final userData = (result.snapshot.value as Map<dynamic, dynamic>?)?.values.first;


          final String fullName = userData['name'] as String? ?? 'Unknown';
          final String? profileImageUrl = userData['profile_image_url'] as String?;

          await FirebaseFirestore.instance
              .collection('loginuser')
              .doc(user.uid)
              .set(
            User1(
              id: user.uid,
              email: user.email!,
              fullName: fullName,
              profileImageUrl: profileImageUrl ?? 'default_image_url',
            ).toMap(),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NameCompanyPage(
                fullName: fullName,
                profileImageUrl: profileImageUrl ?? 'default_image_url',
              ),
            ),
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
        print('Error handling user data: $e');
        // Handle any errors that occur during data handling
      }
    }
  }
  Future<void> _loginWithPhoneNumber(BuildContext context) async {
    try {
      // Collect phone number from user
      final String phoneNumber = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter Phone Number"),
            content: TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(phoneNumberController.text);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );

      if (phoneNumber == null || phoneNumber.isEmpty) {
        // Show an error dialog if the phone number is empty
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Phone Number Error"),
              content: const Text("Phone number cannot be empty."),
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
        return;
      }
      final formattedPhoneNumber = '+91$phoneNumber';
      // Check if the phone number is registered in the 'drivers' collection
      final DatabaseEvent result = await FirebaseDatabase.instance
          .reference()
          .child('drivers')
          .orderByChild('phoneNumber')
          .equalTo(formattedPhoneNumber)
          .once();

      if (result.snapshot.value != null) {
        // If the phone number is registered, proceed with OTP verification
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

  Future<void> _resetPassword(BuildContext context) async {
    try {
      final String email = emailController.text;

      final DatabaseEvent result = await FirebaseDatabase.instance
          .reference()
          .child('drivers')
          .orderByChild('email')
          .equalTo(email)
          .once();

      if (result.snapshot.value != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent to $email'),
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email not registered. Please sign up.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      print('Error sending password reset email: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending password reset email. Please try again.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50.0),

                const Text(
                  'DRIVER BUDDIES 🚗',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30.0),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'User ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),

                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _resetPassword(context);
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _login(context);
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(width: 10.0),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyApps(),
                          ),
                        );
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),


                ElevatedButton.icon(
                  onPressed: () {
                    _loginWithPhoneNumber(context);
                  },
                  icon: const Icon(Icons.phone_android),
                  label: const Text('Sign in with Mobile Number'),
                ),
                const SizedBox(height: 10.0),



                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApps(),
                      ),
                    );
                  },
                  child: const Text("Don't have an account? Sign Up."),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
