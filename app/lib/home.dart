import 'package:app/insure.dart';
import 'package:app/more.dart';
import 'package:app/trips.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        height: 60,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "Icons/Insure.svg",
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0 ? const Color(0xFF6487B5) : const Color(0xFF929292), 
                BlendMode.srcIn
              ), 
            ),
            label: 'Insure',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "Icons/pin.svg",
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1 ? const Color(0xFF6487B5) : const Color(0xFF929292), 
                BlendMode.srcIn
              ),
            ),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "Icons/Leaderboard.svg",
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 2 ? const Color(0xFF6487B5) : const Color(0xFF929292), 
                BlendMode.srcIn
              ),
            ),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "Icons/Icon.svg",
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 3 ? const Color(0xFF6487B5) : const Color(0xFF929292), 
                BlendMode.srcIn
              ),
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "Icons/More.svg",
              height: 26,
              width: 26,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 4 ? const Color(0xFF6487B5) : const Color(0xFF929292), 
                BlendMode.srcIn
              ), 
            ),
            label: 'More',
          ),
        ],
        activeColor: const Color(0xFF6487B5),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const Insure(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const Trips(),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => const Center(child: Text('Leaderboard Tab')),
            );
          case 3:
            return CupertinoTabView(
              builder: (context) => const Center(child: Text('Profile Tab')),
            );
          case 4:
            return CupertinoTabView(
              builder: (context) => const More(),
            );
          default:
            return CupertinoTabView(
              builder: (context) => const Center(child: Text('Unknown Tab')),
            );
        }
      },
    );
  }
}
