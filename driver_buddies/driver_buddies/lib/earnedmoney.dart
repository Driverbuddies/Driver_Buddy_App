import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookings Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Earned(),
    );
  }
}

class Booking {
  final String id;
  final String title;
  final String subtitle;
  final double earnings;

  Booking({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.earnings,
  });
}

class Earned extends StatefulWidget {
  const Earned({Key? key});

  @override
  _EarnedState createState() => _EarnedState();
}

class _EarnedState extends State<Earned> {
  Future<List<Booking>> _getUpcomingBookings() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('bookings').get();

    return querySnapshot.docs.map((DocumentSnapshot document) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return Booking(
        id: document.id,
        title: data['title'] ?? '',
        subtitle: data['subtitle'] ?? '',
        earnings: (data['earnings'] ?? 0.0).toDouble(),
      );
    }).toList();
  }

  double _calculateTotalEarnings(List<Booking> bookings) {
    return bookings.fold(0.0, (sum, booking) => sum + booking.earnings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            final totalEarnings = _calculateTotalEarnings(snapshot.data!);
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final Booking booking = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: const Icon(Icons.event_note, color: Colors.blue),
                          title: Text(booking.title),
                          subtitle: Text(booking.subtitle),
                          trailing: Text('\$${booking.earnings.toStringAsFixed(2)}'),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Earnings: \$${totalEarnings.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
