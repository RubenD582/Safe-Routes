import 'package:app/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, 
      statusBarBrightness: Brightness.dark,
    ));
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF476A7E),
                Color(0xFF375365),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 110),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset(
                        "Icons/logo.svg",
                        width: 240,
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Welcome to\nDiscovery Insure',
                            textAlign: TextAlign.start,
            
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 28,
                              height: 1.2
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'By signing up, you are agreeing to the Terms of service and privacy policy',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Get Started',
                          style: GoogleFonts.openSans(
                            color: const Color(0xFF094990),
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 75,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Terms of service and privacy policy',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40,),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}