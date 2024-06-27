import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';
import 'package:sudia_events/presentation/screens/home/search_location.dart';

class LocationScreen extends StatefulWidget {
  final double lat, long;
  final bool fromHome;
  const LocationScreen(
      {Key? key, required this.lat, required this.long, required this.fromHome})
      : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _city = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchCityName();
  }

  Future<void> _fetchCityName() async {
    try {
      double lat = widget.lat;
      double lon = widget.long;
      print('Latitude: $lat, Longitude: $lon'); // Debug print

      if (lat != 0.0 && lon != 0.0) {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
        if (placemarks.isNotEmpty) {
          setState(() {
            _city = placemarks.first.locality ?? "Unknown Location";
          });
        } else {
          setState(() {
            _city = "Unknown Location";
          });
        }
      } else {
        setState(() {
          _city = "No Location Found";
        });
      }
    } catch (e) {
      setState(() {
        _city = "Error retrieving location";
      });
    }
  }

  bool edit1 = false;
  bool edit2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'عناويني',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    width: .9 * mediawidth(context),
                    height: .1 * mediaheight(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(.4)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المنزل',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _city,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                edit1 = !edit1;
                              });
                            },
                            child: Icon(
                              Icons.edit_location_alt_outlined,
                              color: edit1 ? Colors.green : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: .05 * mediaheight(context)),
                  Container(
                    width: .9 * mediawidth(context),
                    height: .1 * mediaheight(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(.4)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'العمل',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _city,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                edit2 = !edit2;
                              });
                            },
                            child: Icon(
                              Icons.edit_location_alt_outlined,
                              color: edit2 ? Colors.green : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: .05 * mediaheight(context)),
                  MaterialButton(
                    elevation: 0,
                    height: 50,
                    minWidth: .9 * mediawidth(context),
                    color: secondary,
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "اضف عنوان جديد",
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(width: .4 * mediawidth(context)),
                        Icon(Icons.add, color: primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Center(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minWidth: .9 * mediawidth(context),
                  height: 45,
                  color: edit1 || edit2 ? primary : secondary,
                  onPressed: () async {
                    if (widget.fromHome) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchLocationScreen(),
                        ),
                      );
                    } else {
                      // Ensure selectedLocation is not null

                      await sharedpref.setDouble("lat", widget.lat);
                      await sharedpref.setDouble("long", widget.long);
                      print(
                          "Latitude and Longitude updated in SharedPreferences");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BottomBarScreen(
                            id: sharedpref.getString("token")!, public: false, uniquId: '11',date: DateTime.now(),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    widget.fromHome ? "التالي" : "حفظ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
