import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicebooking/pages/provider_chat.dart';
import 'package:servicebooking/services/database.dart';

class ProviderBookings extends StatefulWidget {
  const ProviderBookings({super.key});

  @override
  State<ProviderBookings> createState() => _ProviderBookingsState();
}

class _ProviderBookingsState extends State<ProviderBookings> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Provider Bookings",
          style: TextStyle(
            color: Color(0xff284a79),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: databaseMethods.getProviderBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Bookings Found", style: TextStyle(fontSize: 18)),
            );
          }

          final bookings = snapshot.data!.docs;
          print(bookings);
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data();
              print(booking);
              print(booking["providerProfileImage"]);
              final bookingDoc = bookings[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 8),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                              booking["providerProfileImage"] != null &&
                                  booking["providerProfileImage"]
                                      .toString()
                                      .isNotEmpty
                              ? NetworkImage(booking["providerProfileImage"])
                              : null,
                          child:
                              booking["providerProfileImage"] == null ||
                                  booking["providerProfileImage"]
                                      .toString()
                                      .isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking["customerName"] ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                booking["customerEmail"] ?? "",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Icon(
                          Icons.home_repair_service,
                          color: Color(0xff284a79),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          booking["category"] ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xff284a79),
                        ),
                        const SizedBox(width: 10),
                        Text(booking["bookingDate"] ?? ""),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xff284a79)),
                        const SizedBox(width: 10),
                        Text("${booking["fromTime"]} - ${booking["toTime"]}"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(
                          Icons.currency_rupee,
                          color: Color(0xff284a79),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          booking["hourlyCharge"] ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    if (booking["status"] == "Pending")
                      GestureDetector(
                        onTap: () async {
                          await bookingDoc.reference.update({
                            "status": "Accepted",
                          });
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Pending",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Rejected
                    if (booking["status"] == "Rejected")
                      GestureDetector(
                        onTap: () async {
                          await bookingDoc.reference.update({
                            "status": "Accepted",
                          });

                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Rejected",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    if (booking["status"] == "Accepted")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await bookingDoc.reference.update({
                                "status": "Accepted",
                              });
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Accepted",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              // Navigate to Chat Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProviderChat(
                                    bookingId: bookingDoc.id,
                                    customerId: booking["customerId"],
                                    providerId: booking["providerId"],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff284a79),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.chat,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Chat",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
