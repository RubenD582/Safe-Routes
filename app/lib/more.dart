import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          middle: Text(
            'More',
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
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              CupertinoFormSection(
                children: [
                  CupertinoFormRow(
                    prefix: Row(
                      children: [
                        SvgPicture.asset(
                          'Icons/Wheel.svg', 
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 17),
                        const Text('Find my vehicles'),
                      ],
                    ),
                    child: const SizedBox(
                      height: 35,
                      child: Icon(
                          CupertinoIcons.right_chevron,
                          color: Color.fromARGB(255, 210, 210, 210),
                          size: 18,
                        ),
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: Row(
                      children: [
                        SvgPicture.asset(
                          'Icons/Icon.svg', 
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 17),
                        const Text('Getting started'),
                      ],
                    ),
                    child: const SizedBox(
                      height: 35,
                      child: Icon(
                          CupertinoIcons.right_chevron,
                          color: Color.fromARGB(255, 210, 210, 210),
                          size: 18,
                        ),
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: Row(
                      children: [
                        SvgPicture.asset(
                          'Icons/Sensor.svg', 
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 17),
                        const Text('Vehicle sensor'),
                      ],
                    ),
                    child: const SizedBox(
                      height: 35,
                      child: Icon(
                          CupertinoIcons.right_chevron,
                          color: Color.fromARGB(255, 210, 210, 210),
                          size: 18,
                        ),
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: Row(
                      children: [
                        SvgPicture.asset(
                          'Icons/Email.svg', 
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 17),
                        const Text('Email log book'),
                      ],
                    ),
                    child: const SizedBox(
                      height: 35,
                      child: Icon(
                          CupertinoIcons.right_chevron,
                          color: Color.fromARGB(255, 210, 210, 210),
                          size: 18,
                        ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              CupertinoFormSection(
                children: [
                  CupertinoFormRow(
                    prefix: Row(
                      children: [
                        SvgPicture.asset(
                          'Icons/Settings.svg', 
                          width: 20,
                          height: 20, 
                        ),
                        const SizedBox(width: 17),
                        const Text('Settings'),
                      ],
                    ),
                    child: const SizedBox(
                      height: 35,
                      child: Icon(
                          CupertinoIcons.right_chevron,
                          color: Color.fromARGB(255, 210, 210, 210),
                          size: 18,
                        ),
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: Row(
                      children: [
                        SvgPicture.asset(
                          'Icons/Help.svg', 
                          width: 20,
                          height: 20,  
                        ),
                        const SizedBox(width: 17),
                        const Text('Help'),
                      ],
                    ),
                    child: const SizedBox(
                      height: 35,
                      child: Icon(
                          CupertinoIcons.right_chevron,
                          color: Color.fromARGB(255, 210, 210, 210),
                          size: 18,
                        ),
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: Row(
                      children: [
                        SvgPicture.asset(
                          'Icons/Services.svg', 
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 14),
                        const Text('Emergency Services'),
                      ],
                    ),
                    child: const SizedBox(
                      height: 35,
                      child: Icon(
                          CupertinoIcons.right_chevron,
                          color: Color.fromARGB(255, 210, 210, 210),
                          size: 18,
                        ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}