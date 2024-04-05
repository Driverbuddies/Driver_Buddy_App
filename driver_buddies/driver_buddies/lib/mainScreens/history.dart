import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Booking {
  final String id; // Unique identifier for the booking
  final String firstName;
  final String lastName;
  final String currentLocation;
  final String destinationLocation;
  final String userId; // User ID
  final DateTime dateTime;
  final double estimatedPrice;
  final String status; // Booking status

  Booking({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.currentLocation,
    required this.destinationLocation,
    required this.userId,
    required this.dateTime,
    required this.estimatedPrice,
    required this.status,
  });
}class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<Booking>> _getBookingHistory() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('history')
        .get();

    return querySnapshot.docs.map((DocumentSnapshot document) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return Booking(
        id: document.id,
        userId: data['userDetails']['userId'] ?? '',
        firstName: data['userDetails']['firstName'] ?? '',
        lastName: data['userDetails']['lastName'] ?? '',
        currentLocation: data['bookingDetails']['currentLocation'] ?? '',
        destinationLocation: data['bookingDetails']['destinationLocation'] ?? '',
        estimatedPrice: data['bookingDetails']['estimatedPrice'] ?? 0.0,
        dateTime: data['bookingDetails']['confirmationDateTime'].toDate(),
        status: data['bookingDetails']['status'] ?? '',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
      ),
      body: FutureBuilder(
        future: _getBookingHistory(),
        builder: (context, AsyncSnapshot<List<Booking>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Booking History'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final Booking booking = snapshot.data![index];
                return ListTile(
                  title: Text('User: ${booking.firstName} ${booking.lastName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location: ${booking.currentLocation} to ${booking.destinationLocation}'),
                      Text('Mobile No: ${booking.userId}'),
                      Text('Date & Time: ${DateFormat('yyyy-MM-dd HH:mm').format(booking.dateTime)}'),
                      Text('Estimated Price: ₹${booking.estimatedPrice.toStringAsFixed(2)}'),
                      Text('Status: ${booking.status}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
