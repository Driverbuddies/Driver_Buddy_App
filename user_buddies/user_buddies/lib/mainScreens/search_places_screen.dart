import 'package:flutter/material.dart';
import 'package:user_buddies/models/predicted_places.dart';
import 'package:user_buddies/widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {
  @override
  _SearchPlacesScreenState createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placesPredictedList = [];

  List<String> validLocations = [
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

  void findPlaceAutoCompleteSearch(String inputText) {
    // Filter valid locations based on inputText
    var filteredLocations = validLocations
        .where((location) =>
        location.toLowerCase().contains(inputText.toLowerCase()))
        .toList();

    // Generate PredictedPlaces objects for the filtered locations
    var filteredPredictions = filteredLocations
        .map((location) => PredictedPlaces(
      place_id: '', // Provide a placeholder or handle accordingly
      main_text: location,
      secondary_text: '', // Provide a placeholder or handle accordingly
    ))
        .toList();

    setState(() {
      placesPredictedList = filteredPredictions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //search place ui
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Colors.black54,
              boxShadow: [
                BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 25.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Search & Set DropOff Location",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (valueTyped) {
                              findPlaceAutoCompleteSearch(valueTyped);
                            },
                            decoration: const InputDecoration(
                              hintText: "search here...",
                              fillColor: Colors.white54,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 11.0,
                                top: 8.0,
                                bottom: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //display place predictions result
          (placesPredictedList.length > 0)
              ? Expanded(
            child: ListView.separated(
              itemCount: placesPredictedList.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return PlacePredictionTileDesign(
                  predictedPlaces: placesPredictedList[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 1,
                  color: Colors.white,
                  thickness: 1,
                );
              },
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
