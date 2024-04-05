import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBc-Uh6f8uA9Ag3BXQwdmmR2AkXCUYKAGo",
      appId: "1:706892114240:android:f99b17be66c0a03d7cf2a5",
      messagingSenderId: "706892114240",
      projectId: "new-firebase-setup-e0f49",
      storageBucket: "gs://new-firebase-setup-e0f49.appspot.com",
    ),
  );

  try {
    // Initialize Firebase App Check
    await FirebaseAppCheck.instance.activate();
  } on FirebaseException catch (e) {
    print('FirebaseAppCheck activation failed: $e');
  }

  print("Firebase Initialized");

  runApp(MyAppp(uniqueKey: 'yourUniqueKey'));
}

class MyAppp extends StatelessWidget {
  final String uniqueKey;

  MyAppp({required this.uniqueKey});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(uniqueKey: uniqueKey),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String uniqueKey;

  HomeScreen({required this.uniqueKey});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.directions_car),
            SizedBox(width: 8),
            Text('Driver Buddies'),
          ],
        ),
      ),
      body: PageView(
        children: [
          buildPage(context, "Welcome to Driver Buddies!", Icons.directions_car),
          buildPage(context, "Another Page", Icons.access_time),
          // Add more pages as needed
        ],
      ),
    );
  }

  Widget buildPage(BuildContext context, String text, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade300, Colors.blue.shade500],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the login page with a slide transition
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return MyApp(uniqueKey: uniqueKey); // Adjust this to the actual login page
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Text('Go to Login Page'),
            ),
          ],
        ),
      ),
    );
  }
}
