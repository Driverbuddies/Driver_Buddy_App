import 'package:flutter/material.dart';
import '../mainScreens/booking_page.dart';
import '../mainScreens/history.dart';
import '../mainScreens/upcomingbooking.dart';
import '../earnedmoney.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NameCompanyPage extends StatefulWidget {
  final String? profileImageUrl;
  final String? fullName;

  const NameCompanyPage({Key? key, this.profileImageUrl, this.fullName})
      : super(key: key);

  @override
  _NameCompanyPageState createState() => _NameCompanyPageState();
}

class _NameCompanyPageState extends State<NameCompanyPage> {
  late User _user;
  late String _fullName = '';
  late String _profileImageUrl = '';
  var booking;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      _user = FirebaseAuth.instance.currentUser!;
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(_user.uid)
          .get();

      setState(() {
        _fullName = userSnapshot['name'] ?? ''; // Provide a default value
        _profileImageUrl = userSnapshot['profileImageUrl'] ?? ''; // Provide a default value// Replace 'name' with your Firestore field
      });
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login page or any other desired screen
      Navigator.popUntil(context, ModalRoute.withName('/')); // Navigate to the root route
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DRIVER BUDDIES 🚗'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen (login page)
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
        children: [
          // Display the profile picture
          CircleAvatar(
            // You can set the user's profile picture here
            radius: 90,
            backgroundImage: _profileImageUrl.isNotEmpty
                ? NetworkImage(_profileImageUrl)
                : Image.asset('assets/default_profile_image.jpg').image,
          ),
          const SizedBox(
              height: 16), // Add spacing between profile picture and full name
          // Display the full name
          Text(
            _fullName,
            style: TextStyle(
              fontSize: 20, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Add other text styles if needed
            ),
          ),
          const SizedBox(height: 16), // Add more spacing if necessary
          ListTile(
            leading: const Icon(Icons.schedule), // Upcoming Bookings
            title: const Text('Upcoming Bookings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const  UpcomingBookingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today), // Booking
            title: const Text('Booking'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingPage(booking: booking,))
              );
              // Handle navigation to booking page
            },
          ),
          ListTile(
            leading: const Icon(Icons.history), // History
            title: const Text('History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on), // Earn Money
            title: const Text('Earn Money'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Earned()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout), // Logout
            title: const Text('Logout'),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }
}
