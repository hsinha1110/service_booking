import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Bookings Found",
                style: TextStyle(fontSize: 18),
              ),
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
              final bookingDoc = bookings[index]; // <-- Ye DocumentSnapshot hai

               return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage:
                              booking["providerProfileImage"] != null &&
                                  booking["providerProfileImage"].toString().isNotEmpty
                                  ? NetworkImage(booking["providerProfileImage"])
                                  : null,
                              child: booking["providerProfileImage"] == null ||
                                  booking["providerProfileImage"].toString().isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            Text(
                              booking["customerName"] ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(booking["customerEmail"] ?? ""),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Icon(Icons.home_repair_service,
                            color: Color(0xff284a79)),
                        const SizedBox(width: 10),
                        Text(
                          booking["category"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Color(0xff284a79)),
                        const SizedBox(width: 10),
                        Text(booking["bookingDate"] ?? ""),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Color(0xff284a79)),
                        const SizedBox(width: 10),
                        Text(
                          "${booking["fromTime"]} - ${booking["toTime"]}",
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.currency_rupee,
                            color: Color(0xff284a79)),
                        const SizedBox(width: 10),
                        Text(
                          booking["hourlyCharge"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        booking["status"] ?? "",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (booking["status"] == "Pending")
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                await databaseMethods.rejectBooking(bookingDoc.id);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Booking Rejected"),
                                    backgroundColor: Colors.red,
                                  ),
                                );

                                setState(() {});
                              },
                              child: const Text(
                                "Reject",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () async {
                                await databaseMethods.acceptBooking(bookingDoc.id);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Booking Accepted"),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                setState(() {});
                              },
                              child: const Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
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