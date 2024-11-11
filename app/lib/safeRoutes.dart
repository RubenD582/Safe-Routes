import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:app/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SafeRoutes extends StatefulWidget {
  const SafeRoutes({super.key});

  @override
  State<SafeRoutes> createState() => _SafeRoutesState();
}

class _SafeRoutesState extends State<SafeRoutes> {
  final DraggableScrollableController sheetController = DraggableScrollableController();
  late TextEditingController _textController;
  bool loaded = true;

  GoogleMapController? _mapController;
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 10
  );

  late List<List<dynamic>> path;
  late List<LatLng> coordinates;
  List<LatLng> waypoints = [];
  Set<Marker> markers = {};

  // final List<LatLng> heatmapPoints = [
  //   const LatLng(-26.28669, 27.84833), 
  // ];

  late String _mapStyleString;
  bool _styleLoaded = false;

  Set<Circle> circles = {
    Circle(
      circleId: const CircleId("circle"),
      center: const LatLng(-26.747021773709548, 27.928732037544254),
      radius: 3000,
      fillColor: Colors.red.withOpacity(0.2),
      strokeWidth: 0,
    ),
  };


  Future<void> getPath() async {
    final url = Uri.parse("http://127.0.0.1:5000/api/path");
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'start_lat': -26.703421,
      'start_lng': 27.807695,
      'goal_lat': -26.89500000,
      'goal_lng': 28.09833330,
      'crime_lat': -26.747021773709548,
      'crime_lng': 27.928732037544254,
      // 'crime_lat': 0,
      // 'crime_lng': 0,
      'radius': 1000
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print(data);

        setState(() {
          path = (data['path'] as List<dynamic>)
            .map((e) => (e as List<dynamic>)
                .map((item) => item.toDouble())
                .toList())
            .toList();

          coordinates = pathToLatLng(path);

          waypoints.add(LatLng(path[0][0], path[0][1]));
          waypoints.add(LatLng(path[path.length - 1][0], path[path.length - 1][1]));
          
          loaded = true;
        });

        createMarkers();
      }
    } else {
      if (kDebugMode) {
        print('Failed to load');
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocation() async {
    try {
      final position = await _determinePosition();

      final lat = position.latitude;
      final lng = position.longitude;

      _getPlaces(lat, lng);

      if (_mapController != null) {
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(lat, lng),
              zoom: 14.0,
            ),
          ),
        );
      } else {
        if (kDebugMode) {
          print("MapController is null");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error determining position: $e");
      }
    }
  }

  Future<void> _getPlaces(double lat, double lng) async {
    String amenityQuery = '''
      [out:json];
      (
        node["amenity"](around:1500, $lat, $lng);
        way["amenity"](around:1500, $lat, $lng);
        relation["amenity"](around:1500, $lat, $lng);
      );
      out body;
    ''';

    String amenityUrl = 'https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(amenityQuery)}';

    final response = await http.get(Uri.parse(amenityUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<dynamic> current = [];
      List<Future<void>> reverseGeocodingFutures = [];

      int index = 0;
      for (var place in data['elements']) {
        if (place['tags'] != null && place['tags']['name'] != null) {
          double? placeLat;
          double? placeLon;

          if (place['type'] == 'node') {
            placeLat = place['lat'];
            placeLon = place['lon'];
          }

          else if (place['type'] == 'way') {
            if (place['nodes'] != null && place['nodes'].isNotEmpty) {
              final firstNode = place['nodes'][0];
              final nodeDetails = await _getNodeDetails(firstNode.toString());
              placeLat = nodeDetails['lat'];
              placeLon = nodeDetails['lon'];
            }
          }

          else if (place['type'] == 'relation') {
            if (place['members'] != null && place['members'].isNotEmpty) {
              final firstMember = place['members'][0];
              if (firstMember['type'] == 'node') {
                final nodeDetails = await _getNodeDetails(firstMember['ref']);
                placeLat = nodeDetails['lat'];
                placeLon = nodeDetails['lon'];
              }
            }
          }

          if (placeLat != null && placeLon != null) {
            reverseGeocodingFutures.add(
              _getStreetName(placeLat, placeLon).then((streetName) {
                current.add({
                  'name': place['tags']['name'],
                  'amenity': place['tags']['amenity'],
                  'street': streetName,
                });
              }),
            );
          }

          index++;
          if (index == 3) {
            break;
          }
        }
      }

      await Future.wait(reverseGeocodingFutures);

      setState(() {
        // showBottomSheet(current);
      });
    } else {
      throw Exception('Failed to load places');
    }
  }

  // Helper function to get node details
  Future<Map<String, double>> _getNodeDetails(String nodeId) async {
    String nodeUrl = 'https://overpass-api.de/api/interpreter?data=[out:json];node($nodeId);out;';
    final nodeResponse = await http.get(Uri.parse(nodeUrl));
    if (nodeResponse.statusCode == 200) {
      final nodeData = json.decode(nodeResponse.body);
      final node = nodeData['elements'][0];
      return {
        'lat': node['lat'],
        'lon': node['lon'],
      };
    } else {
      throw Exception('Failed to load node details');
    }
  }

  Future<String> _getStreetName(double lat, double lon) async {
    String reverseGeocodeUrl = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&addressdetails=1';

    final reverseResponse = await http.get(Uri.parse(reverseGeocodeUrl));
    if (reverseResponse.statusCode == 200) {
      final reverseData = json.decode(reverseResponse.body);
      return reverseData['address'] != null ? reverseData['address']['road'] ?? 'Unknown Street' : 'Unknown Street';
    } else {
      throw Exception('Failed to load street name');
    }
  }
  
  // void showBottomSheet(List<dynamic> current) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     showModalBottomSheet(
  //       elevation: 8.0,
  //       barrierColor: Colors.black.withOpacity(0.1),
  //       backgroundColor: Colors.white,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
  //       ),
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (ctx) => SizedBox(
  //         height: 300,
  //         child: Places(places: current),
  //       ),
  //     );
  //   });
  // }

  @override
  void initState() {
    _loadMapStyle();
    _textController = TextEditingController();
    
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
            'Safe Routes',
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
        child: _styleLoaded ? loaded ? Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                getLocation();
              },
              onTap: (LatLng latLng) {
                // Print the latitude and longitude
                if (kDebugMode) {
                  print('Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}');
                }
              },
              circles: circles,
              markers: markers,
              // heatmaps: _heatmaps,
              // polylines: {
              //   Polyline(
              //     polylineId: const PolylineId('path'),
              //     points: coordinates,
              //     color: Colors.red,
              //     width: 5,
              //   ),
              // },
              style: _mapStyleString,
              myLocationEnabled: true,
              myLocationButtonEnabled: true
            ),
          //   AnimatedOpacity(
          //   opacity: 0.6, // Adjust opacity to control the darkness of the overlay
          //   duration: const Duration(milliseconds: 200),
          //   child: Container(
          //     color: Colors.black.withOpacity(0.6), // Dark color with transparency
          //   ),
          // ),
          // DraggableScrollableSheet
          // DraggableScrollableSheet(
          //   builder: (BuildContext context, scrollController) {
          //     return Container(
          //       clipBehavior: Clip.hardEdge,
          //       decoration: BoxDecoration(
          //         color: Theme.of(context).canvasColor,
          //         borderRadius: const BorderRadius.only(
          //           topLeft: Radius.circular(25),
          //           topRight: Radius.circular(25),
          //         ),
          //       ),
          //       child: CustomScrollView(
          //         controller: scrollController,
          //         slivers: [
          //           SliverToBoxAdapter(
          //             child: Center(
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                   color: Theme.of(context).hintColor,
          //                   borderRadius: const BorderRadius.all(Radius.circular(10)),
          //                 ),
          //                 height: 4,
          //                 width: 40,
          //                 margin: const EdgeInsets.symmetric(vertical: 10),
          //               ),
          //             ),
          //           ),
          //           const SliverAppBar(
          //             title: Text('My App'),
          //             primary: false,
          //             pinned: true,
          //             centerTitle: false,
          //           ),
          //           SliverList(
          //             delegate: SliverChildListDelegate(
          //               const [
          //                 ListTile(title: Text('Jane Doe')),
          //                 ListTile(title: Text('Jack Reacher')),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
          ],
        ) : const Center(child: CircularProgressIndicator()) : const Center(child: CircularProgressIndicator()),
      )
    );
  }

  List<LatLng> pathToLatLng(path) {
    List<LatLng> newList = [];
    for (int i = 0; i < path.length; i++) {
      newList.add(LatLng(path[i][0], path[i][1]));
    }

    return newList;
  }

  Set<Marker> createMarkers() {
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
}