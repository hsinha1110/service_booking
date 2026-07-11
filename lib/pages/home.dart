import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicebooking/pages/categories.dart';
import 'package:servicebooking/pages/details.dart';
import 'package:servicebooking/services/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  final List<Map<String, String>> services = [
    {"title": "Cleaning", "image": "assets/images/cleaning.png"},
    {"title": "Painting", "image": "assets/images/painting.png"},
    {"title": "Laundry", "image": "assets/images/laundry.png"},
    {"title": "Repairing", "image": "assets/images/reparing.png"},
  ];

  final List<Map<String, String>> popularServices = [
    {
      "image": "assets/images/girl.jpg",
      "title": "Home Cleaning",
      "name": "Shivani Sharma",
      "rating": "4.9",
      "price": "\$24/Hour",
    },
    {
      "image": "assets/images/boy.jpg",
      "title": "Painter",
      "name": "Dilip Verma",
      "rating": "4.5",
      "price": "\$18/Hour",
    },
    {
      "image": "assets/images/boy1.jpg",
      "title": "Laundry",
      "name": "Robin Singh",
      "rating": "4.3",
      "price": "\$18/Hour",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 50.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 239, 230, 231),
                    Color.fromARGB(255, 197, 227, 244),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder<DocumentSnapshot>(
                              future: databaseMethods.getUserDetails(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(
                                    height: 56,
                                    child: SizedBox(),
                                  );
                                }

                                if (!snapshot.hasData || snapshot.data!.data() == null) {
                                  return const Text("Hi");
                                }

                                final userData =
                                snapshot.data!.data() as Map<String, dynamic>;

                                return SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Hi ${userData["name"]}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.grey.shade200,
                                        backgroundImage:
                                        (userData["profileImage"] != null &&
                                            userData["profileImage"] != "")
                                            ? NetworkImage(userData["profileImage"])
                                            : null,
                                        child:
                                        (userData["profileImage"] == null ||
                                            userData["profileImage"] == "")
                                            ? const Icon(Icons.person)
                                            : null,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          "Which service do\n you need ?",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff284a79),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "How can I Help You?",
                              hintStyle: const TextStyle(color: Colors.black45),
                              border: InputBorder.none,
                              suffixIcon: const Icon(
                                Icons.search,
                                color: Color(0xff284a79),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 10.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(
                          height: 100,
                          child: FutureBuilder<QuerySnapshot>(
                            future: databaseMethods.getServiceDetails(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                  child: Text("No Categories"),
                                );
                              }

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final data =
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>;

                                  List<dynamic> images = data["imageUrls"] ?? [];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => Categories(
                                            category: data["category"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 90,
                                      margin: const EdgeInsets.only(right: 15),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              child:Image.network(
                                                images.first,
                                                fit: BoxFit.cover,
                                              )
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            data["category"],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color(0xff284a79),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Popular Services",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff284a79),
                ),
              ),
            ),
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: databaseMethods.getServiceDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Services Found"),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final services = snapshot.data!.docs[index].data();

                    List images = services["imageUrls"] ?? [];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Details(services: services),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 197, 227, 244),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                images.isNotEmpty ? images.first : "",
                                width: 90,
                                height: 136,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    services["category"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    "By ${services["providerName"]}",
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    "${services["hourlyCharge"]}/Hour",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 94, 172, 202),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "${services["hourlyCharge"]}/Hour",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => Details(services: services),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff284a79),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              "Book Now",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
