import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/utils/google_search/place_type.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
// import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/home/location.dart';

class SearchLocationScreen extends StatefulWidget {
  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Location'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Center(
                  child: SearchLocation(
                    apiKey:
                        'AIzaSyCKckCh7RP4ezDtY4F2m5CEV0Y8tfntDFk', // Replace with your Google Maps API key
                    placeholder: 'Search location...',
                    placeType: PlaceType.address,
                    hasClearButton: true,
                    onSelected: (Place place) async {
                      final geolocation = await place.geolocation;
                      setState(() {
                        selectedLocation = LatLng(
                          geolocation!.coordinates!.latitude,
                          geolocation.coordinates!.longitude,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            if (selectedLocation != null)
              Container(
                width: mediawidth(context),
                height: .7 * mediaheight(context),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: selectedLocation!,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('selected-location'),
                      position: selectedLocation!,
                      infoWindow: InfoWindow(
                        title: 'Selected Location',
                        snippet:
                            'Lat: ${selectedLocation!.latitude}, Lng: ${selectedLocation!.longitude}',
                      ),
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {},
                ),
              ),
            SizedBox(height: 20),
            MaterialButton(
              color: primary,
              minWidth: .9 * mediawidth(context),
              elevation: 0,
              onPressed: () {
                if (selectedLocation != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LocationScreen(
                        lat: selectedLocation!.latitude,
                        long: selectedLocation!.longitude,
                        fromHome: false,
                      ),
                    ),
                  );
                } else {
                  // Handle case where no location is selected
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('No Location Selected'),
                      content:
                          Text('Please select a location before proceeding.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text(
                "التالي",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
