import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../booking.dart'; // Import the Booking class

class BookingPage extends StatelessWidget {
  final Booking booking;

  const BookingPage({Key? key, required this.booking}) : super(key: key);

  Future<void> _confirmBooking(String bookingId) async {
    try {
      // Add your logic for confirming a booking (e.g., update status, notify user, etc.)
      // ...

      // Delete the confirmed booking from the 'bookings' collection
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .delete();

      // You may add additional logic as needed
    } catch (e) {
      print('Error confirming booking: $e');
      // Handle the error, show an error message, etc.
    }
  }

  Future<void> _cancelBooking(String bookingId) async {
    try {
      // Add your logic for canceling a booking (e.g., update status, notify user, etc.)
      // ...

      // Delete the canceled booking from the 'bookings' collection
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .delete();

      // You may add additional logic as needed
    } catch (e) {
      print('Error canceling booking: $e');
      // Handle the error, show an error message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${booking.firstName} ${booking.lastName}'),
            Text('Location: ${booking.currentLocation} to ${booking.destinationLocation}'),
            Text('Mobile No: ${booking.userId ?? 'N/A'}'),
            Text('Date & Time: ${DateFormat('yyyy-MM-dd HH:mm').format(booking.dateTime)}'),
            Text('Estimated Price: ₹${booking.estimatedPrice.toStringAsFixed(2)}'),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _confirmBooking(booking.id);
                    Navigator.pop(context); // Go back to the previous screen
                  },
                  child: const Text('Confirm'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _cancelBooking(booking.id);
                    Navigator.pop(context); // Go back to the previous screen
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
