import 'package:app/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetail extends StatefulWidget {
  const TripDetail({super.key});

  @override
  State<TripDetail> createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {
  int? _currentSegment = 0;

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(-26.703421, 27.80798),
    zoom: 13.0,
  );

  final List<List<double>> path = [[-26.2849501, 27.8486375], [-26.2862776, 27.8503428], [-26.2863191, 27.8509567], [-26.2841538, 27.8545482], [-26.2838997, 27.8549554], [-26.2815039, 27.8589242], [-26.2813425, 27.8591891], [-26.2812309, 27.8593832], [-26.2793384, 27.8625939], [-26.2791855, 27.862509], [-26.2788031, 27.8623138], [-26.278381, 27.8621013], [-26.2779379, 27.861882], [-26.2768701, 27.8613476], [-26.2750891, 27.860842], [-26.2728825, 27.8607434], [-26.2713919, 27.8606542], [-26.2712902, 27.8606502], [-26.2709291, 27.860638], [-26.2708279, 27.8606267], [-26.2704737, 27.860614], [-26.2697401, 27.8605764], [-26.2696168, 27.8605691], [-26.269238, 27.8605483], [-26.2691484, 27.8605463], [-26.2687065, 27.8605235], [-26.2682366, 27.860499], [-26.2682043, 27.8604969], [-26.2676844, 27.8604698], [-26.2675908, 27.8604652], [-26.2677356, 27.8624439], [-26.2671722, 27.8625751], [-26.2660152, 27.8628658], [-26.2645728, 27.8632381], [-26.2640107, 27.8633675], [-26.263164, 27.8635925], [-26.2617767, 27.863967], [-26.2592865, 27.8646147], [-26.2587713, 27.8647426], [-26.2583263, 27.8648505], [-26.2578687, 27.8649692], [-26.2566426, 27.8652718], [-26.2552677, 27.8656173], [-26.2547643, 27.8657412], [-26.254257, 27.865872], [-26.2537749, 27.8659963], [-26.2532929, 27.8661205], [-26.2527701, 27.8662553], [-26.2522837, 27.8663847], [-26.2518008, 27.8664966], [-26.249893, 27.8669804], [-26.2493808, 27.8671037], [-26.2493429, 27.8671136], [-26.2488534, 27.8672431], [-26.2483047, 27.8673729], [-26.2478004, 27.8674959], [-26.2477443, 27.8681198], [-26.2476971, 27.868626], [-26.2476494, 27.869158], [-26.2476275, 27.8694253], [-26.2475976, 27.869698], [-26.2475469, 27.8702257], [-26.2474942, 27.8708366], [-26.2474196, 27.8715929], [-26.2464365, 27.8736217], [-26.2453122, 27.873626], [-26.2453074, 27.8743945], [-26.245299, 27.8751455], [-26.2452894, 27.8763103], [-26.245293, 27.8775018], [-26.2452918, 27.8776708]];

  late List<LatLng> coordinates;

  Set<Circle> circles = {
    Circle(
      circleId: const CircleId("circle"),
      center: const LatLng(-26.2611111, 27.875),
      radius: 1000,
      fillColor: Colors.red.withOpacity(0.3), // Red background with opacity
      strokeWidth: 0,
    ),
  };

  List<LatLng> waypoints = [
    const LatLng(-26.28669, 27.84833), 
    const LatLng(-26.24528, 27.87794), 
  ];

  @override
  void initState() {
    super.initState();
    coordinates = pathToLatLng(path);
    if (kDebugMode) {
      print(coordinates);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        elevation: 8.0,
        barrierColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        context: context,
        builder: (ctx) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10, 
                offset: const Offset(0, -5),
              ),
            ],
          ),
          width: double.infinity,
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC6C6C6),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity, 
                padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                child: CupertinoSlidingSegmentedControl<int>(
                  children: const {
                    0: Text(
                      'Trip Info',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    1: Text(
                      'Vehicle Info',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  },
                  groupValue: _currentSegment,
                  onValueChanged: (int? value) {
                    setState(() {
                      _currentSegment = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 1,
                color: const Color(0xFFD4D4D4),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Acceleration",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          )
                        ),
                        Text(
                          "Perfect",
                          style: TextStyle(
                            color: Color(0xFF0E9E59),
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          )
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Braking",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          )
                        ),
                        Text(
                          "4 Points detucted",
                          style: TextStyle(
                            color: Color(0xFFED3E57),
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          )
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Cornering",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          )
                        ),
                        Text(
                          "Perfect",
                          style: TextStyle(
                            color: Color(0xFF0E9E59),
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          )
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Speeding",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          )
                        ),
                        Text(
                          "Perfect",
                          style: TextStyle(
                            color: Color(0xFF0E9E59),
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          )
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Cellphone use",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          )
                        ),
                        Text(
                          "Perfect",
                          style: TextStyle(
                            color: Color(0xFF0E9E59),
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                          )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          middle: Text(
            'Trip details',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w600,
            ),
          ),
          border: const Border(
            bottom: BorderSide(
              color: Color(0xFF1D4A88),
              width: 1.0, 
            ),
          ),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  CupertinoIcons.back,
                  color: Color(0xFF1D4A88),
                  size: 24,
                ),
                const SizedBox(width: 5),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Back',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: const Color(0xFF1D4A88),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            },
          ),
        ),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialPosition,
              myLocationButtonEnabled: false,
              onMapCreated: (controller) {
                setState(() {

                });
              },
              circles: circles,
              markers: createMarkers(),
              polylines: {
                Polyline(
                  polylineId: const PolylineId('path'),
                  points: coordinates,
                  color: Colors.red,
                  width: 5,
                ),
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.92,
                    height: 124,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(70, 107, 107, 107),
                          blurRadius: 9,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          // const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "Icons/pin.svg",
                                    colorFilter: const ColorFilter.mode(Color(0xFF4F9B81), BlendMode.srcIn),  
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Pretoria",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                          
                              const Text(
                                "Today at 12:03",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 11),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 18),
                                    child: Container(
                                      height: 26,
                                      width: 2,
                                      color: const Color(0xFFCFCFCF)
                                    ),
                                  ),

                                  const Text(
                                    "55,1 km 41 mins",
                                    style: TextStyle(
                                      color: Color(0xFF767676)
                                    )
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 11),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "Icons/pin.svg",
                                    colorFilter: const ColorFilter.mode(Color(0xFFD54F6C), BlendMode.srcIn),  
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Rosebank",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                          
                              const Text(
                                "Today at 12:44",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
    
          ],
        ),
      ),
    );
  }

  List<LatLng> pathToLatLng(path) {
    List<LatLng> newList = [];
    for (int i = 0; i < path.length; i++) {
      newList.add(LatLng(path[i][0], path[i][1]));
    }

    return newList;
  }

  // Function to create custom markers for waypoints
  Set<Marker> createMarkers() {
    Set<Marker> markers = {};

    // Create custom red marker icon
    BitmapDescriptor customIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

    // Add markers for each waypoint
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
}