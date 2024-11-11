import 'package:app/search.dart';
import 'package:app/tripDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Insure extends StatefulWidget {
  const Insure({super.key});

  @override
  State<Insure> createState() => _InsureState();
}

class _InsureState extends State<Insure> {
  final List<List<double>> path = [[-26.2849501, 27.8486375], [-26.2862776, 27.8503428], [-26.2863191, 27.8509567], [-26.2841538, 27.8545482], [-26.2838997, 27.8549554], [-26.2815039, 27.8589242], [-26.2813425, 27.8591891], [-26.2812309, 27.8593832], [-26.2793384, 27.8625939], [-26.2791855, 27.862509], [-26.2788031, 27.8623138], [-26.278381, 27.8621013], [-26.2779379, 27.861882], [-26.2768701, 27.8613476], [-26.2750891, 27.860842], [-26.2728825, 27.8607434], [-26.2713919, 27.8606542], [-26.2712902, 27.8606502], [-26.2709291, 27.860638], [-26.2708279, 27.8606267], [-26.2704737, 27.860614], [-26.2697401, 27.8605764], [-26.2696168, 27.8605691], [-26.269238, 27.8605483], [-26.2691484, 27.8605463], [-26.2687065, 27.8605235], [-26.2682366, 27.860499], [-26.2682043, 27.8604969], [-26.2676844, 27.8604698], [-26.2675908, 27.8604652], [-26.2677356, 27.8624439], [-26.2671722, 27.8625751], [-26.2660152, 27.8628658], [-26.2645728, 27.8632381], [-26.2640107, 27.8633675], [-26.263164, 27.8635925], [-26.2617767, 27.863967], [-26.2592865, 27.8646147], [-26.2587713, 27.8647426], [-26.2583263, 27.8648505], [-26.2578687, 27.8649692], [-26.2566426, 27.8652718], [-26.2552677, 27.8656173], [-26.2547643, 27.8657412], [-26.254257, 27.865872], [-26.2537749, 27.8659963], [-26.2532929, 27.8661205], [-26.2527701, 27.8662553], [-26.2522837, 27.8663847], [-26.2518008, 27.8664966], [-26.249893, 27.8669804], [-26.2493808, 27.8671037], [-26.2493429, 27.8671136], [-26.2488534, 27.8672431], [-26.2483047, 27.8673729], [-26.2478004, 27.8674959], [-26.2477443, 27.8681198], [-26.2476971, 27.868626], [-26.2476494, 27.869158], [-26.2476275, 27.8694253], [-26.2475976, 27.869698], [-26.2475469, 27.8702257], [-26.2474942, 27.8708366], [-26.2474196, 27.8715929], [-26.2464365, 27.8736217], [-26.2453122, 27.873626], [-26.2453074, 27.8743945], [-26.245299, 27.8751455], [-26.2452894, 27.8763103], [-26.245293, 27.8775018], [-26.2452918, 27.8776708]];
  late List<LatLng> coordinates;

  List<Map<String, dynamic>> items = [
    {
      'car': 'Audi A1 Sportback 1.0 TFSI (2020) / HY97397GP',
      'time': 'Yesterday at 14:52',
      'destination': 'Irene to Midrand',
      'information': '24.2km, 41 mins',
      'score': 'Perfect'
    },
  ];

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(-26.28669, 27.84833),
    zoom: 11.5,
  );

  @override
  void initState() {
    coordinates = pathToLatLng(path);

    super.initState();
  }

  List<LatLng> pathToLatLng(path) {
    List<LatLng> newList = [];
    for (int i = 0; i < path.length; i++) {
      newList.add(LatLng(path[i][0], path[i][1]));
    }

    return newList;
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
            'Insure',
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
        ), 
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Current Status",
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.93,
                          height: 145,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Silver",
                                      style: GoogleFonts.openSans(
                                        color: const Color(0xFF7D7D7D),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                      )
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                const Row(
                                  children: [
                                    Text(
                                      "Driving Status",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 140, 140, 140),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900
                                      )
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: (MediaQuery.of(context).size.width * 0.8) / 5,
                                          height: 7,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFF3C74AD),
                                                Color(0xFF89B3D9),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                                
                                                
                                        Container(
                                          width: (MediaQuery.of(context).size.width * 0.8) / 5,
                                          height: 7,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFB66844), 
                                                Color(0xFFF49656),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(context).size.width * 0.8) / 5,
                                          height: 7,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFF818588),
                                                Color(0xFFDADBDF),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(context).size.width * 0.8) / 5,
                                          height: 7,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFBA9443),
                                                Color(0xFFEED753), 
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(context).size.width * 0.8) / 5,
                                          height: 7,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFBCC4D7),
                                                Color(0xFFC6BAC8),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: ((34 / 2) - (7 / 2)) * -1,
                                      left: MediaQuery.of(context).size.width / 2 - 47,
                                      child: Container(
                                        height: 34,
                                        width: 34,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF6F6F6),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Gradient layer
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return const LinearGradient(
                                                  colors: [
                                                    Color(0xFF818588),
                                                    Color(0xFFDADBDF),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ).createShader(bounds);
                                              },
                                              child: Container(
                                                height: 34,
                                                width: 34,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Car image centered on top
                                            Container(
                                              height: 27,
                                              width: 27,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF818588), // Starting color
                                                    Color(0xFFDADBDF), // Ending color
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 7),
                                                  child: SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child: Image.asset(
                                                      "Icons/StatusCar.png",
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )



                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      "200",
                                      style: GoogleFonts.openSans(
                                        color: const Color.fromARGB(255, 140, 140, 140),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "points to get Gold",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 140, 140, 140),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900
                                      )
                                    ),
                                  ],
                                ),
                              ]
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xFFDDDDDD)
                ),
                const SizedBox(height: 35),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xFFDDDDDD)
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Daily Drive points",
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                              )
                            ),
                            SvgPicture.asset(
                              "Icons/Info.svg",
                              height: 20,
                              width: 20,
                              colorFilter: const ColorFilter.mode(Color(0xFF0E76EE), BlendMode.srcIn),  
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(  
                          children: [
                            SizedBox(
                              width: 300,
                              child: Text(
                                "View the progess of your daily drive goals. Drive well throughout the day to earn rewards.",
                                style: GoogleFonts.openSans(
                                  color: const Color.fromARGB(215, 140, 140, 140),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500
                                )
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.93,
                          height: 145,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.465,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            "Icons/Car.svg",
                                            height: 14,
                                            width: 14,
                                          ),
                                          const SizedBox(height: 8,),
                                          Text(
                                            "56/60",
                                            style: GoogleFonts.openSans(
                                              color: const Color(0xFF1797C6),
                                              fontWeight: FontWeight.w800,
                                              fontSize: 24,
                                            ),
                                          ),
                                          Text(
                                            "Daily points left",
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(0.8),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.38,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                "Icons/Car.svg",
                                                height: 14,
                                                width: 14,
                                                colorFilter: const ColorFilter.mode(Color(0xFFDC6135), BlendMode.srcIn),  
                                              ),
                                              const SizedBox(height: 8,),
                                              Text(
                                                "0",
                                                style: GoogleFonts.openSans(
                                                  color: const Color(0xFFDC6135),
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              Text(
                                                "Points lost today",
                                                style: TextStyle(
                                                  color: Colors.black.withOpacity(0.8),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 29),
                  child: Container(
                    width: double.infinity,
                    height: 0.5,
                    color: const Color(0xFFDDDDDD)
                  ),
                ),
                CupertinoFormSection.insetGrouped(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  margin: EdgeInsets.zero,
                  children: [
                    const CupertinoFormRow(
                      prefix: Text('Daily Drive points history'),
                      child: SizedBox(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 0),
                            Icon(
                              CupertinoIcons.right_chevron,
                              color: Color.fromARGB(255, 210, 210, 210),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const CupertinoFormRow(
                      prefix: Text('How do I earn driving behaviour points?'),
                      child: SizedBox(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 0),
                            Icon(
                              CupertinoIcons.right_chevron,
                              color: Color.fromARGB(255, 210, 210, 210),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const CupertinoFormRow(
                      prefix: Text('Vitality Active Rewards'),
                      child: SizedBox(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 0),
                            Icon(
                              CupertinoIcons.right_chevron,
                              color: Color.fromARGB(255, 210, 210, 210),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                      child: const CupertinoFormRow(
                        prefix: Text('Introducing Discovery Safe routes'),
                        child: SizedBox(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 0),
                              Icon(
                                CupertinoIcons.right_chevron,
                                color: Color.fromARGB(255, 210, 210, 210),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Container(
                  width: double.infinity,
                  color:  Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "September 2024",
                              style: GoogleFonts.openSans(
                                fontSize: 19,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Text(
                              "Total driving score",
                              style: GoogleFonts.openSans(
                                color: const Color(0xFF787679),
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                              "1731/2400",
                              style: GoogleFonts.openSans(
                                fontSize: 25,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width * 0.8) / 1.74,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF05A1C1),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                ),
                              
                                Stack(
                                  children: [
                                    Container(
                                      width: (MediaQuery.of(context).size.width * 0.8) / 1.74,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF2F1F3),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 75,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF20A698),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(0),
                                          bottomRight: Radius.circular(0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "0",
                              style: GoogleFonts.openSans(
                                color: const Color(0xFF787679),
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                              )
                            ),
                            Text(
                              "2 400",
                              style: GoogleFonts.openSans(
                                color: const Color(0xFF787679),
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.455,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(10), 
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Driving Profile",
                                          style: GoogleFonts.openSans(
                                            color: const Color(0xFF8A888B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                          )
                                        ),
                                        const SizedBox(height: 5,),
                                        Text(
                                          "1131/1800",
                                          style: GoogleFonts.openSans(
                                            color: const Color(0xFF10ABC0),
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                      ],
                                    ),
                                    const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          CupertinoIcons.right_chevron,
                                          color: Color.fromARGB(255, 210, 210, 210),
                                          size: 20,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.455,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(10), 
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Booster points",
                                          style: GoogleFonts.openSans(
                                            color: const Color(0xFF8A888B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                          )
                                        ),
                                        const SizedBox(height: 5,),
                                        Text(
                                          "600/600",
                                          style: GoogleFonts.openSans(
                                            color: const Color(0xFF20A698),
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                      ],
                                    ),
                                    const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          CupertinoIcons.right_chevron,
                                          color: Color.fromARGB(255, 210, 210, 210),
                                          size: 20,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xFFDDDDDD)
                ),
                listTile(items[0]),
                const SizedBox(height: 40,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listTile(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Latest trip",
                      style: GoogleFonts.openSans(
                        fontSize: 19,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25,),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xFFDDDDDD),
                ),
                const SizedBox(height: 8),
                CupertinoFormSection.insetGrouped(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  margin: EdgeInsets.zero,
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => const TripDetail(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Trip details',
                              style: GoogleFonts.openSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.right_chevron,
                              color: Color.fromARGB(255, 210, 210, 210),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: const Color(0xFFDDDDDD),
          ),
      
        ],
      ),
    );
  }
}