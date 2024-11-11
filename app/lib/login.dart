import 'package:app/home.dart';
import 'package:app/landing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.red
    ));
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          middle: Text(
            'Login',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w600,
            ),
          ),
          border: const Border(
            bottom: BorderSide(
              color: Colors.white,
              width: 1.0, 
            ),
          ),
          padding: const EdgeInsetsDirectional.only(start: 0),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.back,
                  color: Color(0xFF1D4A88),
                  size: 28,
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (context) => const Landing(),
                ),
              );
            },
          ),
        ), 
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 40,),
              Row(
                children: [
                  SvgPicture.asset(
                    "Icons/login-user.svg",
                    width: 32
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Enter ID number',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              const Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'Please enter your ID or passport number to verify your account',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50,),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0), 
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "ID or Passport number",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Color(0xFF4B4B4B),
                      fontSize: 17
                    ),
                    contentPadding: EdgeInsets.only(
                      left: 8.0, 
                      bottom: 17.0,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, 
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF9B9B9B), 
                        width: 1.0, 
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF9B9B9B), 
                        width: 1.0, 
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF004B8E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  },
                  child: Text(
                    'Continue',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}