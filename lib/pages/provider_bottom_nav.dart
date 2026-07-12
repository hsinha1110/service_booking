import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:servicebooking/pages/provider_bookings.dart';
import 'package:servicebooking/pages/provider_profile.dart';
import 'package:servicebooking/service_provider/service_details.dart';

class ProviderBottomNav extends StatefulWidget {

  const ProviderBottomNav({super.key});

  @override
  State<StatefulWidget> createState() => _ProviderBottomNavState();
}

class _ProviderBottomNavState extends State<ProviderBottomNav> {
  final List<Widget> pages = [
    const ServiceDetails(),
    const ProviderBookings(),
    const ProviderProfile(),
  ];
  late ServiceDetails serviceDetails;
  late ProviderBookings providerBookings;
  late ProviderProfile providerProfile;


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
          Icon(Icons.book_outlined, color: Colors.white, size: 25.0),
          Icon(Icons.person, color: Colors.white, size: 25.0),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
