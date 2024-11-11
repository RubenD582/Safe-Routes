import 'dart:async';

import 'package:app/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trips extends StatefulWidget {
  const Trips({super.key});

  @override
  State<Trips> createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  List<Map<String, dynamic>> items = [
    {
      'car': 'Audi A1 Sportback 1.0 TFSI (2020) / HY97397GP',
      'time': 'Yesterday at 14:52',
      'destination': 'Irene to Midrand',
      'information': '24.2km, 41 mins',
      'score': 'Perfect'
    },
    {
      'car': 'Audi A1 Sportback 1.0 TFSI (2020) / HY97397GP',
      'time': 'Yesterday at 7:55',
      'destination': 'Irene to Midrand',
      'information': '24.2km, 41 mins',
      'score': 'Perfect'
    },
  ];

  final List<List<double>> path = [[-26.2849501, 27.8486375], [-26.2862776, 27.8503428], [-26.2863191, 27.8509567], [-26.2841538, 27.8545482], [-26.2838997, 27.8549554], [-26.2815039, 27.8589242], [-26.2813425, 27.8591891], [-26.2812309, 27.8593832], [-26.2793384, 27.8625939], [-26.2791855, 27.862509], [-26.2788031, 27.8623138], [-26.278381, 27.8621013], [-26.2779379, 27.861882], [-26.2768701, 27.8613476], [-26.2750891, 27.860842], [-26.2728825, 27.8607434], [-26.2713919, 27.8606542], [-26.2712902, 27.8606502], [-26.2709291, 27.860638], [-26.2708279, 27.8606267], [-26.2704737, 27.860614], [-26.2697401, 27.8605764], [-26.2696168, 27.8605691], [-26.269238, 27.8605483], [-26.2691484, 27.8605463], [-26.2687065, 27.8605235], [-26.2682366, 27.860499], [-26.2682043, 27.8604969], [-26.2676844, 27.8604698], [-26.2675908, 27.8604652], [-26.2677356, 27.8624439], [-26.2671722, 27.8625751], [-26.2660152, 27.8628658], [-26.2645728, 27.8632381], [-26.2640107, 27.8633675], [-26.263164, 27.8635925], [-26.2617767, 27.863967], [-26.2592865, 27.8646147], [-26.2587713, 27.8647426], [-26.2583263, 27.8648505], [-26.2578687, 27.8649692], [-26.2566426, 27.8652718], [-26.2552677, 27.8656173], [-26.2547643, 27.8657412], [-26.254257, 27.865872], [-26.2537749, 27.8659963], [-26.2532929, 27.8661205], [-26.2527701, 27.8662553], [-26.2522837, 27.8663847], [-26.2518008, 27.8664966], [-26.249893, 27.8669804], [-26.2493808, 27.8671037], [-26.2493429, 27.8671136], [-26.2488534, 27.8672431], [-26.2483047, 27.8673729], [-26.2478004, 27.8674959], [-26.2477443, 27.8681198], [-26.2476971, 27.868626], [-26.2476494, 27.869158], [-26.2476275, 27.8694253], [-26.2475976, 27.869698], [-26.2475469, 27.8702257], [-26.2474942, 27.8708366], [-26.2474196, 27.8715929], [-26.2464365, 27.8736217], [-26.2453122, 27.873626], [-26.2453074, 27.8743945], [-26.245299, 27.8751455], [-26.2452894, 27.8763103], [-26.245293, 27.8775018], [-26.2452918, 27.8776708]];

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(-26.28669, 27.84833),
    zoom: 11.5,
  );

  // ignore: unused_field
  late String _mapStyleString;
  // ignore: unused_field
  bool _styleLoaded = false;
  late List<LatLng> coordinates;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();

    coordinates = pathToLatLng(path);
  }

  List<LatLng> pathToLatLng(path) {
    List<LatLng> newList = [];
    for (int i = 0; i < path.length; i++) {
      newList.add(LatLng(path[i][0], path[i][1]));
    }

    return newList;
  }

  List<LatLng> waypoints = [
    const LatLng(-26.28669, 27.84833), 
    const LatLng(-26.24528, 27.87794), 
  ];

  Set<Marker> createMarkers() {
    Set<Marker> markers = {};

    BitmapDescriptor customIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

    for (int i = 0; i < waypoints.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('waypoint_$i'),
          position: waypoints[i],
          icon: customIcon,
        ),
      );
    }

    return markers;
  }

  Future<void> _loadMapStyle() async {
    try {
      final string = await rootBundle.loadString('Assets/map_style.json');
      setState(() {
        _mapStyleString = string;
        _styleLoaded = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading map style: $e');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          middle: Text(
            'Trips',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
            child: Text(
              'Add',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D4A88),
                fontSize: 15
              ),
            ),
          ),
          border: const Border(
            bottom: BorderSide(
              color: Color(0xFF1D4A88),
              width: 1.0, 
            ),
          ),
        ), 
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: List.generate(items.length, (index) {
                    return listTile(items[index]);
                  }),
                ),
              ),
              const SizedBox(height: 35,)
            ],
          ),
        ),
      ),
    );
  }

  Widget listTile(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(top: 35,),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFFDDDDDD),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        item['car']!,
                        style: GoogleFonts.openSans(
                          color: Colors.black.withOpacity(1),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['time']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17
                        ),
                      ),
                      Text(
                        item['score']!,
                        style: GoogleFonts.openSans(
                          color: const Color(0xFF0E9E59),
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: initialPosition,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        scrollGesturesEnabled: false,
                        zoomGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
        
                        },
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId('path'),
                            points: coordinates,
                            color: Colors.black,
                            width: 3,
                          ),
                        },
                      )
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['destination']!,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16
                        ),
                      ),
                      Text(
                        item['information']!,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

