import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servicebooking/service_provider/service_details.dart';
import 'package:servicebooking/services/database.dart';
import 'firebase_options.dart';
import 'package:servicebooking/pages/login.dart';
import 'package:servicebooking/pages/bottom_nav.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    DatabaseMethods databaseMethods = DatabaseMethods();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!authSnapshot.hasData) {
            return const Login();
          }

          return FutureBuilder(
            future: DatabaseMethods().getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Color(0xff284a79),
                        strokeWidth: 5,
                      ),
                    ),
                  ),                );
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;

              if (data["role"] == "Customer") {
                return const BottomNav();
              } else {
                return const ServiceDetails();
              }
            },
          );
        },
      ),
    );
  }
}
