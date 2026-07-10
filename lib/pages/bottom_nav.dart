import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:servicebooking/pages/chat_page.dart';
import 'package:servicebooking/pages/home.dart';
import 'package:servicebooking/pages/order.dart';
import 'package:servicebooking/pages/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<StatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final List<Widget> pages = [Home(), Order(), ChatPage(), Profile()];

  late Home homePage;
  late Order order;
  late ChatPage chatPage;
  late Profile profilePage;

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white, size: 25.0),
          Icon(Icons.shop_outlined, color: Colors.white, size: 25.0),
          Icon(Icons.chat_outlined, color: Colors.white, size: 25.0),
          Icon(Icons.person, color: Colors.white, size: 25.0),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
