import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:app/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  GoogleMapController? mapController;
  final Set<Polyline> _polylines = {};
  Set<Marker> _markers = Set();
  // final Set<Circle> _circles = {};
  List<LatLng> _path = [];
  
  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(-26.21286, 27.89548),
    zoom: 13.0,
  );

  TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late Position position;
  List<Map<String, dynamic>> _searchResults = [];
  bool isLoading = false;
  Timer? _debounce;

  late LatLng destination;
  Circle danger = Circle(
    circleId: const CircleId("danger_zone"),
    center: const LatLng(0, 0),
    radius: 100,
    strokeWidth: 0,
    fillColor: Colors.red.withOpacity(0.2),
  );

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      // setState(() {
      //   if (_focusNode.hasFocus) {
      //     _modalHeight = MediaQuery.of(context).size.height * 0.9;
      //   } else {
      //     _modalHeight = 400; // Restore the height when the text field loses focus
      //   }
      // });
    });

    controller.text = 'Dobsonville Mall';

    setLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        elevation: 0.0,
        barrierColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState ) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
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
                    // height: 400,
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 8),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Container(
                        //         height: 5,
                        //         width: 35,
                        //         decoration: BoxDecoration(
                        //           color: const Color(0xFFC6C6C6),
                        //           borderRadius: BorderRadius.circular(10.0),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 10),
                          child: Row(
                            children: [
                              Flexible(
                                child: CupertinoSearchTextField(
                                  focusNode: _focusNode,
                                  placeholder: "Search maps",
                                  controller: controller,
                                  onChanged: (query) async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                              
                                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                                              
                                    _debounce = Timer(const Duration(seconds: 1), () async {
                                      if (query.isNotEmpty) {
                                        var results = await _searchStreets(query, position.latitude, position.longitude);
                                        setState(() {
                                          _searchResults = results;
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      } else {
                                        setState(() {
                                          _searchResults = [];
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Text(
                                'Cancel',
                                overflow: TextOverflow.ellipsis,
                                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                                  color: Colors.blueAccent[400],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        isLoading ?
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: CupertinoActivityIndicator(),
                            )
                          ],
                        )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (ctx, index) {
                                final street = _searchResults[index];
                  
                                Icon icon = const Icon(CupertinoIcons.map_pin, color: Colors.white, size: 18,);
                                Color color = const Color(0xFFFF2C3B);
                                if (street['type'] == 'supermarket' || street['type'] == 'mall') {
                                  icon = const Icon(CupertinoIcons.bag_fill, color: Colors.white, size: 18,);
                                  color = const Color(0xFFFFBE00);
                                }
                  
                                if (street['type'] == 'restaurant' || street['type'] == 'fast_food') {
                                  icon = const Icon(Icons.restaurant_rounded, color: Colors.white, size: 18,);
                                  color = const Color(0xFFFF7F00);
                                }
                  
                                if (street['type'] == 'fitness_centre' || street['type'] == 'sports_centre') {
                                  icon = const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 18,);
                                  color = const Color(0xFF30CBE7);
                                }
                  
                                if (street['type'] == 'zoo') {
                                  icon = const Icon(Icons.pets, color: Colors.white, size: 18,);
                                  color = const Color(0xFFF34DB9);
                                }
                  
                                if (street['type'] == 'park') {
                                  icon = const Icon(Icons.park, color: Colors.white, size: 18,);
                                  color = const Color(0xFF35DA62);
                                }
                  
                                return GestureDetector(
                                  onTap: () async {
                                    try {
                                      destination = LatLng(street['latitude'], street['longitude']);
                                      final Map<String, dynamic> requestData = {
                                        'start_lat': position.latitude,
                                        'start_lng': position.longitude,
                                        'goal_lat': street['latitude'],
                                        'goal_lng': street['longitude'],
                                        'crime_lat': danger.center.latitude,
                                        'crime_lng': danger.center.longitude,
                                        'crime_radius': 500
                                      };

                                      // Make the POST request to the Flask API
                                      final response = await http.post(
                                        Uri.parse('http://127.0.0.1:5000/api/path'),  // Flask server URL
                                        headers: {'Content-Type': 'application/json'},
                                        body: json.encode(requestData),
                                      );
                                      if (response.statusCode == 200) {
                                        // Successful response
                                        final data = json.decode(response.body);
                                        final List<dynamic> pathData = data['path'];

                                        setState(() {
                                          _path = pathData
                                              .map((item) => LatLng(item[0], item[1]))
                                              .toList();
                                        });
                                        _addPolylineToMap();
                                        _addWaypointsMarkers();
                                        _moveCameraToFitPolyline();
                                      } else {

                                      }
                                    } catch (e) {
                                      print('Error occurred: $e');
                                    }
                                  },
                                  child: ListTile(
                                    minTileHeight: 65,
                                    title: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius: const BorderRadius.all(Radius.circular(100))
                                            ),
                                            child: Center(
                                              child: icon
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded( 
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,  
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded( // This will ensure text is properly constrained and overflow is handled
                                                    child: Text(
                                                      '${street['street']}',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: CupertinoTheme.of(context).textTheme.textStyle, 
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Expanded( 
                                                    child: Text(
                                                      '${formatDistance(street['distance'])} • ${street['location']}',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                                                        color: Colors.black.withOpacity(0.5),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                  
                                              const SizedBox(height: 17,),
                                  
                                              Padding(
                                                padding: const EdgeInsets.only(left: 0),
                                                child: Container(
                                                  height: 1,
                                                  width: double.infinity,
                                                  color: Colors.black.withOpacity(0.1),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      );
    });
  }

  void _addPolylineToMap() {
    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        visible: true,
        points: _path,
        width: 5,
        color: Colors.red,
      ));
    });
  }

  void _addWaypointsMarkers() {
    if (_path.isNotEmpty) {
      // Start waypoint
      _markers.add(Marker(
        markerId: const MarkerId('start'),
        position: _path.first,
        infoWindow: const InfoWindow(title: 'Start'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));

      // End waypoint
      _markers.add(Marker(
        markerId: const MarkerId('end'),
        position: _path.last,
        infoWindow: const InfoWindow(title: 'End'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
  }


  void _moveCameraToFitPolyline() {
    if (_path.isEmpty) return;

    // Calculate bounds (LatLngBounds)
    double? north, south, east, west;

    for (LatLng point in _path) {
      if (north == null || point.latitude > north) north = point.latitude;
      if (south == null || point.latitude < south) south = point.latitude;
      if (east == null || point.longitude > east) east = point.longitude;
      if (west == null || point.longitude < west) west = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(south!, west!),
      northeast: LatLng(north!, east!),
    );

    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100),
    );
  }

  void setLocation() async {
    position = await _getCurrentLocation();
  }

  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)}m'; 
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(2)}km';
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
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
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialPosition,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              onTap: (LatLng currentPosition) async {
                if (kDebugMode) {
                  print("${currentPosition.latitude}, ${currentPosition.longitude}");
                }

                setState(() {
                  danger = Circle(
                    circleId: const CircleId("danger_zone"),
                    center: LatLng(currentPosition.latitude, currentPosition.longitude),
                    radius: 500,
                    strokeWidth: 0,
                    fillColor: Colors.red.withOpacity(0.2),
                  );
                });

                final Map<String, dynamic> requestData = {
                  'start_lat': position.latitude,
                  'start_lng': position.longitude,
                  'goal_lat': destination.latitude,
                  'goal_lng': destination.longitude,
                  'crime_lat': danger.center.latitude,
                  'crime_lng': danger.center.longitude,
                  'crime_radius': 500
                };

                final response = await http.post(
                  Uri.parse('http://127.0.0.1:5000/api/path'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode(requestData),
                );

                if (response.statusCode == 200) {
                  // Successful response
                  final data = json.decode(response.body);
                  final List<dynamic> pathData = data['path'];

                  setState(() {
                    _path = pathData
                        .map((item) => LatLng(item[0], item[1]))
                        .toList();
                  });

                  print('Route fetched successfully');
                  
                  // Add polyline to map
                  _addPolylineToMap();
                  _addWaypointsMarkers();
                } else {
                  print('Error: ${response.statusCode}');
                }

              },
              polylines: _polylines,
              markers: _markers,
              circles: {danger},
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _searchStreets(String searchQuery, double lat, double lon) async {
    List<Map<String, dynamic>> matchingResults = [];
    try {
      const baseUrl = 'https://nominatim.openstreetmap.org/search';

      final Map<String, List<String>> searchMapping = {
        'school': ['amenity=school', 'amenity=college', 'amenity=university'],
        'golf': ['leisure=golf_course', 'sport=golf'],
        'casino': ['amenity=casino', 'leisure=casino', 'gambling=casino'],
        'restaurant': ['amenity=restaurant', 'amenity=fast_food'],
        'hospital': ['amenity=hospital', 'healthcare=hospital'],
        'pharmacy': ['amenity=pharmacy', 'healthcare=pharmacy'],
        'police': ['amenity=police'],
        'bank': ['amenity=bank', 'amenity=atm'],
        'gym': ['leisure=fitness_centre', 'leisure=sports_centre'],
        'park': ['leisure=park', 'leisure=garden'],
      };

      List<String> searchTypes = [];
      searchMapping.forEach((key, values) {
        if (searchQuery.toLowerCase().contains(key)) {
          searchTypes.addAll(values);
        }
      });

      searchTypes.add(searchQuery);

      List<Future<http.Response>> searchRequests = [];
      double offset = 0.1;

      while (matchingResults.isEmpty) {
        for (var searchType in searchTypes) {
          final queryParams = {
            'format': 'json',
            'addressdetails': '1',
            'limit': '10',
            'lat': lat.toString(),
            'lon': lon.toString(),
            'countrycodes': 'za',
            'bounded': '1',
            'viewbox': '${lon - offset},${lat + offset},${lon + offset},${lat - offset}',
          };

          if (searchType.contains('=')) {
            final parts = searchType.split('=');
            queryParams[parts[0]] = parts[1];
            queryParams['q'] = searchQuery;
          } else {
            queryParams['q'] = searchType;
          }

          final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
          final headers = {
            'Accept-Language': 'en',
            'User-Agent': 'YourAppName/1.0',
          };

          searchRequests.add(http.get(uri, headers: headers));
        }

        final responses = await Future.wait(searchRequests);
        searchRequests.clear();

        for (var response in responses) {
          if (response.statusCode == 200) {
            final List<dynamic> results = json.decode(response.body);
            for (var result in results) {
              final address = result['address'] as Map<String, dynamic>;

              String displayName = _extractDisplayNameWithContext(result, address, searchQuery);
              String location = _formatLocation(address);

              final double latitude = double.parse(result['lat']);
              final double longitude = double.parse(result['lon']);
              final double distance = _calculateDistance(lat, lon, latitude, longitude);

              bool isDuplicate = matchingResults.any((existing) =>
                  (existing['latitude'] == latitude &&
                      existing['longitude'] == longitude) ||
                  existing['street'].toLowerCase() == displayName.toLowerCase());

              if (!isDuplicate) {
                matchingResults.add({
                  'street': displayName,
                  'houseNumber': address['house_number'] ?? '',
                  'latitude': latitude,
                  'longitude': longitude,
                  'distance': double.parse(distance.toStringAsFixed(2)),
                  'location': location,
                  'type': result['type'],
                  'importance': result['importance'] ?? 0.0,
                  'category': _extractCategory(result, address),
                });
              }
            }
          }
        }

        if (matchingResults.isEmpty) {
          if (kDebugMode) {
            print('Expanding viewbox by offset: $offset');
          }
          offset += 1;
          if (offset > 10.0) {
            break;
          }
        }
      }

      matchingResults.sort((a, b) {
        return (a['distance'] as double).compareTo(b['distance'] as double);
      });

      return matchingResults.take(10).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error searching locations: $e');
      }
      return [];
    }
  }


  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000; 

    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;

    double a = sin(dLat / 2) * sin(dLat / 2) +
              cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
              sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  String _extractDisplayNameWithContext(Map<String, dynamic> result, Map<String, dynamic> address, String searchQuery) {
    String name = result['name'] ?? '';
    String type = result['type'] ?? '';
    
    if (name.isEmpty) {
      List<String> nameParts = [];
      
      if (address['suburb'] != null) {
        nameParts.add(address['suburb']);
      }
      
      if (type.isNotEmpty) {
        nameParts.add(type.replaceAll('_', ' ').toUpperCase());
      }
      
      name = nameParts.join(' ');
    }
    
    String city = address['city'] ?? address['town'] ?? '';
    if (city.isNotEmpty && !name.toLowerCase().contains(city.toLowerCase())) {
      name += ', $city';
    }
    
    return name;
  }


  String _extractCategory(Map<String, dynamic> result, Map<String, dynamic> address) {
    if (result.containsKey('amenity')) {
      return result['amenity'].toString();
    }
    
    final possibleCategories = ['leisure', 'tourism', 'shop', 'historic'];
    for (var category in possibleCategories) {
      if (result.containsKey(category)) {
        return result[category].toString();
      }
    }
    
    return '';
  }

  String _formatLocation(Map<String, dynamic> address) {
    List<String> locationParts = [];
    
    if (address['road'] != null) locationParts.add(address['road']);
    if (address['suburb'] != null) locationParts.add(address['suburb']);
    if (address['city'] != null) locationParts.add(address['city']);
    if (address['town'] != null && address['city'] == null) locationParts.add(address['town']);
    
    return locationParts.join(' • ');
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permission is denied');
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
