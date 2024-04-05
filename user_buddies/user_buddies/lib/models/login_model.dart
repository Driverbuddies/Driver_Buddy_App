import 'user_model.dart';
class LoginInfo {
  String mobileNumber;
  String currentLocation;
  String destinationLocation;
  double estimatedPrice;

  LoginInfo({
    required this.mobileNumber,
    required this.currentLocation,
    required this.destinationLocation,
    required this.estimatedPrice,

  });

  Map<String, dynamic> toMap() {
    return {
      'mobileNumber': mobileNumber,
      'currentLocation': currentLocation,
      'destinationLocation': destinationLocation,
      'estimatedPrice': estimatedPrice,

    };
  }

  factory LoginInfo.fromMap(Map<String, dynamic> map) {
    return LoginInfo(
      mobileNumber: map['mobileNumber'] ?? '',
      currentLocation: map['currentLocation'] ?? '',
      destinationLocation: map['destinationLocation'] ?? '',
      estimatedPrice: (map['estimatedPrice'] ?? 0.0).toDouble(),

    );
  }
}
