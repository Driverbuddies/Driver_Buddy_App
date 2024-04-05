
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/driver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';


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

  runApp(const MyApps());
}

class MyApps extends StatelessWidget {
  const MyApps({super.key, Key? keyss});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Upload(),
    );
  }
}

class Upload extends StatefulWidget {
  const Upload({super.key, Key? keys});

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  DateTime selectedDate = DateTime.now();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController dlController = TextEditingController();
  TextEditingController issueDateController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController referredByController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  String message = '';
  String aadharMessage = '';
  String dlMessage = '';
  String passwordMessage = '';
  String? _selectedState; // Use nullable types
  String? _selectedCity; // Use nullable types

// List of available states
  List<String> _states = [
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
  ];
  List<String> _cities = [
    'Bhopal', 'Indore',
    'Jaipur', 'Udaipur', 'Jodhpur', 'Kota',
    'Vadodara', 'Rajkot', 'Surat', 'Ahmedabad',
    'Nagpur', 'Nashik', 'Aurangabad', 'Pune', 'Mumbai', 'Kolhapur',
    'Hyderabad',
    'Chennai', 'Coimbatore',
    'Vijayawada', 'Visakhapatnam',
    'Kochi',
    'Noida', 'Lucknow', 'Kanpur', 'Varanasi', 'Prayagraj', 'Agra', 'Ayodhya',
    'Shimla',
    'Chandigarh', 'Amritsar', 'Ludhiana',
    'Mysuru', 'Bangalore', 'Belgaum',
    'Dehradun', 'Haridwar',
    'Delhi',
    'Ranchi',
    'Siliguri', 'Kolkata',
    'Patna',
    'Goa',
    'Guwahati',
    'Imphal',
    'Raipur',
    'Gurugram',
  ];



  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = formatDate(picked, [yyyy, '-', mm, '-', dd]);
      });
    }
  }

  bool isDateValid(DateTime selectedDate) {
    final now = DateTime.now();
    var age = now.year - selectedDate.year;

    if (now.month < selectedDate.month ||
        (now.month == selectedDate.month && now.day < selectedDate.day)) {
      age--;
    }

    return age >= 18;
  }

  File? selectedImage;
  File? selectedFile;



  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
    await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }


  // Image and file URLs
  String? profileImageUrl;
  String? aadharFileUrl;
  String? dlFileUrl;

  Future<void> sendDataToServer() async {
    try {
      // Create a new user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final formattedPhoneNumber = '+91${mobileController.text}';

      // Upload profile image to Firebase Storage
      if (selectedImage != null) {
        final profileImageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${DateTime.now().toString()}');
        await profileImageRef.putFile(selectedImage!);
        profileImageUrl = await profileImageRef.getDownloadURL();
      }

      // Upload Aadhar file to Firebase Storage
      if (selectedFile != null) {
        final aadharFileRef = FirebaseStorage.instance
            .ref()
            .child('aadhar_files/${DateTime.now().toString()}');
        await aadharFileRef.putFile(selectedFile!);
        aadharFileUrl = await aadharFileRef.getDownloadURL();
      }

      // Upload DL file to Firebase Storage
      // ... similar to Aadhar file upload ...

      // Save other user details in Firestore
      final DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");

      // Generate a unique ID for the driver
      final String driverId = driversRef.push().key ?? '';

      // Add the driver information to the database
      final Driver driver = Driver(
        id: driverId,
        name: nameController.text,
        email: emailController.text,
        profileImageUrl: profileImageUrl,
        aadharFileUrl: aadharFileUrl,
        dlFileUrl: dlFileUrl,
        dob: dobController.text,
        aadhar: aadharController.text,
        dl: dlController.text,
        issueDate: issueDateController.text,
        expiryDate: expiryDateController.text,
        referredBy: referredByController.text,
        password: '',
        phoneNumber: formattedPhoneNumber,
      );

      driversRef.child(driverId).set(driver.toMap());

      print('Data stored in Realtime Database');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed up successfully!'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error storing data in Realtime Database: $e');
      // Handle the error, show an error message to the user, etc.
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyApp(uniqueKey: '',)),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Upload Your Information",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Personal ID Proof",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name (Driving License)',
                          hintText: 'Enter full name as per your driving license',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: _getImage,
                        ),
                        selectedImage != null
                            ? Image.file(selectedImage!, height: 50, width: 50)
                            : SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email ID',
                    hintText: 'eg: xxxx@xxxx.com',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  onChanged: (enteredEmail) {
                    setState(() {
                      if (isEmailValid(enteredEmail)) {
                        message = '';
                      } else {
                        message = 'Please enter a valid email address!';
                      }
                    });
                  },
                ),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: dobController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Date of Birth',
                          hintText: 'eg: yyyy-MM-dd',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context, dobController);
                      },
                    ),
                  ],
                ),
                if (dobController.text.isNotEmpty)
                  isDateValid(selectedDate)
                      ? const Text("")
                      : const Text(
                    "Your age should be more than 18 years. Please enter a valid date of birth.",
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: aadharController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Aadhar card number',
                    hintText: 'eg: 12-digit number',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.length == 12) {
                        aadharMessage = '';
                      } else {
                        aadharMessage =
                        'Aadhar card number should be of 12 digits.';
                      }
                    });
                  },
                ),
                Text(
                  aadharMessage,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Upload your Aadhar Card:"),
                ElevatedButton(
                  onPressed: _getImage,
                  child: const Text('Pick File'),
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: dlController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Driving License number',
                    hintText: 'eg: 16-digit number',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.length == 16) {
                        dlMessage = '';
                      } else {
                        dlMessage =
                        'Driving License number should be of 16 digits.';
                      }
                    });
                  },
                ),
                Text(
                  dlMessage,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                const Text("Upload your Driving License:"),
                ElevatedButton(
                  onPressed: _getImage,
                  child: const Text('Pick File'),
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'eg: XXXXXXXXXX',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                SizedBox(height: 20),
                // Dropdown for State
                Text('State'),
                DropdownButtonFormField<String>(
                  value: 'Madhya Pradesh',
                  items: _states.map((state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedState = value ?? '';
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('City'),
                DropdownButtonFormField<String>(
                  value: 'Indore',
                  items: _cities.map((cities) {
                    return DropdownMenuItem<String>(
                      value: cities,
                      child: Text(cities),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCity = value ?? '';
                    });
                  },
                ),
                SizedBox(height: 20),


                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: issueDateController,
                        decoration: const InputDecoration(
                          labelText: 'Issue Date',
                          hintText: 'yyyy-MM-dd',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () {
                          _selectDate(context, issueDateController);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: TextFormField(
                        controller: expiryDateController,
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date',
                          hintText: 'yyyy-MM-dd',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () {
                          _selectDate(context, expiryDateController);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: referredByController,
                  decoration: const InputDecoration(
                    labelText: 'Referred By (Optional)',
                    hintText: 'eg: XXXXXXX',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Create Password field
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Create Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // Confirm Password field
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      if (passwordController.text == value) {
                        passwordMessage = '';
                      } else {
                        passwordMessage = 'Passwords do not match';
                      }
                    });
                  },
                ),
                Text(
                  passwordMessage,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),

                // Continue button

                ElevatedButton(
                  onPressed: sendDataToServer,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isFormValid() {
    return isEmailValid(emailController.text) &&
        isDateValid(selectedDate) &&
        aadharMessage.isEmpty &&
        dlMessage.isEmpty &&
        passwordMessage.isEmpty;
  }
}
