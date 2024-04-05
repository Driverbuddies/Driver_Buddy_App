import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'booking_page.dart';
import '../booking.dart';

class UpcomingBookingsPage extends StatefulWidget {
  const UpcomingBookingsPage({Key? key}) : super(key: key);

  @override
  _UpcomingBookingsPageState createState() => _UpcomingBookingsPageState();
}

class _UpcomingBookingsPageState extends State<UpcomingBookingsPage> {
  Future<List<Booking>> _getUpcomingBookings() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('status', isEqualTo: 'Upcoming')
        .get();

    return querySnapshot.docs.map((DocumentSnapshot document) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // Check if 'confirmationDateTime' is not null before calling .toDate()
      DateTime dateTime = data['confirmationDateTime'] != null
          ? data['confirmationDateTime'].toDate()
          : DateTime.now(); // You can replace DateTime.now() with a default value

      return Booking(
        id: document.id,
        userId: data['userId'] ?? '',
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        currentLocation: data['currentLocation'] ?? '',
        destinationLocation: data['destinationLocation'] ?? '',
        estimatedPrice: data['estimatedPrice'] ?? 0.0,
        dateTime: dateTime,
        status: data['status'] ?? '',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Bookings'),
      ),
      body: FutureBuilder(
        future: _getUpcomingBookings(),
        builder: (context, AsyncSnapshot<List<Booking>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Upcoming Bookings'));
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
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(booking: booking),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
