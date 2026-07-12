import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servicebooking/pages/provider_bottom_nav.dart';
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
    DatabaseMethods databaseMethods = DatabaseMethods();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          print("Auth User => ${authSnapshot.data?.uid}");

          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!authSnapshot.hasData) {
            print("No Logged In User");
            return const Login();
          }

          return FutureBuilder<DocumentSnapshot>(
            future: databaseMethods.getUserDetails(),
            builder: (context, snapshot) {
              print("Future State => ${snapshot.connectionState}");

              if (snapshot.hasData) {
                print(snapshot.data!.data());
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                print(snapshot.error);
                return const Scaffold(body: Center(child: Text("Error")));
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;

              print("Role => ${data["role"]}");

              if (data["role"] == "Customer") {
                return const BottomNav();
              } else if (data["role"] == "Service Provider") {
                return const ProviderBottomNav();
              } else {
                return const Login();
              }
            },
          );
        },
      ),
    );
  }
}
