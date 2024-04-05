
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
}