import 'package:app/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );


    return MaterialApp(
      title: 'Discovery Insure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF004B8E),
        highlightColor: const Color(0xFF004B8E),
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
        ),
      ),
      home: const Landing()
    );
  }
}
