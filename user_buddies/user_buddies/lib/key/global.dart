import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_buddies/models/direction_details_info.dart';
import 'package:user_buddies/models/user_model.dart';



final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
Users? userModelCurrentInfo;
List dList = []; //online-active drivers Information List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String cloudMessagingServerToken = "key=AAAAqo4oJOg:APA91bHuVtVtkuF6JeHkiwt7J5LY6m2yRPDIwX1fyD_RtNcUcyRkWbnzEr1D0Oo06pG-ekgS29aJ-wVUefdV1jqn5itSXm-OM29WznvZwZCEGZpXTZRaZxXVMKQMx7VXiYBANHoaoTjQ";
String userDropOffAddress = "";
String driverCarDetails="";
String driverName="";
String driverPhone="";
double countRatingStars=0.0;
String titleStarsRating="";