
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;
import 'confirm_location.dart';
import 'models/login_model.dart';
import 'models/user_model.dart';


class UserModel extends Users {
  late String email;
  late String state;

  UserModel({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String state,
    required String city,
  }) : super(
    uid: uid,
    firstName: firstName,
    lastName: lastName,
    mobileNumber: mobileNumber,
    city: city,
  ) {
    this.email = email;
    this.state = state;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': mobileNumber,
      'state': state,
      'city': city,
    };
  }
  // New static method to retrieve user details by mobile number
  static Future<UserModel?> getUserByMobileNumber(String mobileNumber) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('userapp')
          .where('mobileNumber', isEqualTo: mobileNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        print('User data: $userData');
        return UserModel(
          uid: userData['uid'] ?? '',
          firstName: userData['firstName'] ?? '',
          lastName: userData['lastName'] ?? '',
          email: userData['email'] ?? '',
          mobileNumber: userData['mobileNumber'] ?? '',
          state: userData['state'] ?? '',
          city: userData['city'] ?? '',
        );
      } else {
        print('No user found for mobile number: $mobileNumber');
        return null;
      }
    } catch (e) {
      print('Error retrieving user by mobile number: $e');
      return null;
    }
  }

}


class DeliveryMapPage extends StatefulWidget {
  final String mobileNumber; // Add this line

  DeliveryMapPage({
    Key? key,
    required this.mobileNumber, // Add this line
  }) : super(key: key);

  @override
  _DeliveryMapPageState createState() => _DeliveryMapPageState();
}

class _DeliveryMapPageState extends State<DeliveryMapPage> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = LatLng(22.9734, 78.6569);
  TextEditingController currentLocationController = TextEditingController();
  TextEditingController destinationLocationController = TextEditingController();
  String _firstName = '';
  String _lastName = '';

  List<String> deliveryLocationNames = [
    'Madhya Pradesh',
    'Rajasthan',
    'Gujarat',
    'Maharashtra',
    'Telangana',
    'Tamil Nadu',
    'Andhra Pradesh',
    'Kerala',
    'Uttar Pradesh',
    'Himachal Pradesh',
    'Punjab',
    'Karnataka',
    'Uttarakhand',
    'Delhi',
    'Jharkhand',
    'West Bengal',
    'Bihar',
    'Goa',
    'Assam',
    'Manipur',
    'Chhattisgarh',
    'Haryana',
    'Bhopal',
    'Indore',
    'Jaipur',
    'Udaipur',
    'Jodhpur',
    'Kota',
    'Vadodara',
    'Rajkot',
    'Surat',
    'Ahmedabad',
    'Nagpur',
    'Nashik',
    'Aurangabad',
    'Pune',
    'Mumbai',
    'Kolhapur',
    'Hyderabad',
    'Chennai',
    'Coimbatore',
    'Vijayawada',
    'Visakhapatnam',
    'Kochi',
    'Noida',
    'Lucknow',
    'Kanpur',
    'Varanasi',
    'Prayagraj',
    'Agra',
    'Ayodhya',
    'Shimla',
    'Chandigarh',
    'Amritsar',
    'Ludhiana',
    'Mysuru',
    'Bangalore',
    'Belgaum',
    'Dehradun',
    'Haridwar',
    'Delhi',
    'Ranchi',
    'Siliguri',
    'Kolkata',
    'Patna',
    'Goa',
    'Guwahati',
    'Imphal',
    'Raipur',
    'Gurugram',
  ];
  List<LatLng> deliveryLocations = [];

  LatLng? currentLocation;
  LatLng? destinationLocation;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
    _getDeliveryLocations();
    _getCurrentLocation();
  }

  Future<void> _checkAndRequestPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> _getDeliveryLocations() async {
    for (String locationName in deliveryLocationNames) {
      try {
        List<Location> locations = await locationFromAddress(locationName);
        if (locations.isNotEmpty) {
          LatLng coordinates =
          LatLng(locations.first.latitude, locations.first.longitude);
          deliveryLocations.add(coordinates);
        }
      } catch (e) {
        print('Error converting $locationName to coordinates: $e');
      }
    }
    setState(() {});
  }
  Future<void> _getCurrentLocation() async {
    try {
      location.LocationData locationData =
      await location.Location().getLocation();
      currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation!.latitude,
        currentLocation!.longitude,
      );
      currentLocationController.text = placemarks.first.locality ?? '';

      // Retrieve user information from the 'userapp' collection
      UserModel? user = await UserModel.getUserByMobileNumber(widget.mobileNumber);

      if (user != null) {
        // Use user information if needed
        setState(() {
          _firstName = user.firstName;
          _lastName = user.lastName;
        });
      } else {
        print('User not found with mobile number: ${widget.mobileNumber}');
      }

      setState(() {});
    } catch (e) {
      print('Error getting current location: $e');
    }
  }



  Future<double> calculateEstimatedPrice(double distanceInKm) async {
    double ratePerKm = 10.0;
    double estimatedPrice = distanceInKm * ratePerKm;
    return estimatedPrice;
  }

  Future<double> _calculateDistance(
      LatLng startCoordinates, LatLng endCoordinates) async {
    double distance = await Geolocator.distanceBetween(
      startCoordinates.latitude,
      startCoordinates.longitude,
      endCoordinates.latitude,
      endCoordinates.longitude,
    );
    return distance / 1000;
  }

  Future<void> _storeLocation(String locationType, LatLng locationCoordinates) async {
    try {
      print('Storing location for mobile number: ${widget.mobileNumber}');

      // Retrieve user information from the 'userapp' collection
      UserModel? user = await UserModel.getUserByMobileNumber(widget.mobileNumber);

      // Check if the user exists
      if (user != null) {
        // Store location information in the 'userlocation' collection
        await _firestore.collection('userlocation').doc(widget.mobileNumber).set({
          'mobileNumber': user.mobileNumber,
          'locationType': locationType,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'latitude': locationCoordinates.latitude,
          'longitude': locationCoordinates.longitude,
          'currentLocation': locationType == 'current',
          'destinationLocation': locationType == 'destination',
        });

        // Update the UI to reflect the changes
        setState(() {
          _firstName = user.firstName;
          _lastName = user.lastName;
        });

        print('Location stored successfully!');
      } else {
        print('User not found with mobile number: ${widget.mobileNumber}');
      }
    } catch (e) {
      print('Error storing location information: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Column(
        children: [
          TextField(
            controller: currentLocationController,
            decoration: InputDecoration(labelText: 'Current Location'),
            readOnly: true,
          ),
          TextField(
            controller: destinationLocationController,
            decoration: InputDecoration(labelText: 'Destination Location'),
            readOnly: true,
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: currentLocation ?? _initialPosition,
                zoom: 12.0,
              ),
              markers: _createMarkers(),
              onTap: (LatLng latLng) {
                setState(() {
                  destinationLocation = latLng;
                  _getCityNameFromCoordinates(
                      latLng, destinationLocationController);
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              LatLng? selectedLocation = await _selectLocationOnMap();
              if (selectedLocation != null) {
                setState(() {
                  currentLocation = selectedLocation;
                  _getCityNameFromCoordinates(
                      currentLocation!, currentLocationController);
                });
              }
            },
            child: Text('Select Current Location on Map'),
          ),
          ElevatedButton(
            onPressed: () async {
              LatLng? selectedLocation = await _selectLocationOnMap();
              if (selectedLocation != null) {
                setState(() {
                  destinationLocation = selectedLocation;
                  _getCityNameFromCoordinates(
                      destinationLocation!, destinationLocationController);
                });
              }
            },
            child: Text('Select Destination Location on Map'),
          ),
          ElevatedButton(
            onPressed: currentLocation != null && destinationLocation != null
                ? () async {
              // Store the current location with the mobile number
              await _storeLocation('current', currentLocation!);
              // Store the destination location with the mobile number
              await _storeLocation('destination', destinationLocation!);

              Users appUser = Users(
                uid: 'uid',
                firstName: 'firstName',
                lastName: 'lastName',
                mobileNumber:'mobileNumber',
                city: currentLocationController.text,
              );

              LoginInfo loginInfo = LoginInfo(
                mobileNumber: 'mobileNumber',
                currentLocation: currentLocationController.text,
                destinationLocation: destinationLocationController.text,
                estimatedPrice: await calculateEstimatedPrice(
                  await _calculateDistance(
                    currentLocation!,
                    destinationLocation!,
                  ),
                ),

              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmLocationPage(
                    mobileNumber:'mobileNumber',
                    currentLocation: currentLocationController.text,
                    destinationLocation: destinationLocationController.text,
                    onLocationConfirmed: (bool isConfirmed) {
                      // Handle confirmation
                    },
                    estimatedPrice: loginInfo.estimatedPrice,

                  ),
                ),
              );
            }
                : null,
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = Set<Marker>();

    if (currentLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
    }

    if (destinationLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId('destinationLocation'),
          position: destinationLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Destination Location'),
        ),
      );
    }

    return markers;
  }

  Future<void> _getCityNameFromCoordinates(
      LatLng coordinates, TextEditingController controller) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );
      controller.text = placemarks.first.locality ?? '';
    } catch (e) {
      print('Error getting city name from coordinates: $e');
    }
  }

  Future<LatLng?> _selectLocationOnMap() async {
    LatLng? selectedLocation;

    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: double.maxFinite,
              height: 300,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: currentLocation ?? _initialPosition,
                  zoom: 12.0,
                ),
                onTap: (LatLng latLng) {
                  selectedLocation = latLng;
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error selecting location on map: $e');
    }

    return selectedLocation;
  }
}