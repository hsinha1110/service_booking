import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicebooking/pages/login.dart';
import 'package:servicebooking/services/database.dart';

class ProviderProfile extends StatefulWidget {
  const ProviderProfile({super.key});

  @override
  State<ProviderProfile> createState() => _ProviderProfileState();
}

class _ProviderProfileState extends State<ProviderProfile> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  Future<void> logout() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Logout"),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await databaseMethods.logOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const Login(),
        ),
            (route) => false,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Color(0xff284a79),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: databaseMethods.getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff284a79),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(
              child: Text("No Profile Found"),
            );
          }

          final user =
          snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: NetworkImage(
                    user["profileImage"],
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  user["name"],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff284a79),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  user["email"],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [

                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Color(0xff284a79),
                        ),
                        title: const Text("Name"),
                        subtitle: Text(user["name"]),
                      ),

                      const Divider(height: 0),

                      ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Color(0xff284a79),
                        ),
                        title: const Text("Email"),
                        subtitle: Text(user["email"]),
                      ),

                      const Divider(height: 0),

                      ListTile(
                        leading: const Icon(
                          Icons.work,
                          color: Color(0xff284a79),
                        ),
                        title: const Text("Role"),
                        subtitle: Text(user["role"]),
                      ),
                      const Divider(height: 0),

                      ListTile(
                        onTap: logout,
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),



              ],
            ),
          );
        },
      ),
    );
  }
}