import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servicebooking/services/database.dart';

class BookDetails extends StatefulWidget {
  final Map<String, dynamic> services;
  const BookDetails({super.key, required this.services});


  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  final TextEditingController customerName = TextEditingController();
  final TextEditingController customerEmail = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController fromTime = TextEditingController();
  final TextEditingController toTime = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  String profileImage = "";
  DatabaseMethods databaseMethods = DatabaseMethods();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  Future<void> getUserData() async {
    DocumentSnapshot doc = await databaseMethods.getUserDetails();

    if (doc.exists) {
      final user = doc.data() as Map<String, dynamic>;

      setState(() {
        customerName.text = user["name"] ?? "";
        customerEmail.text = user["email"] ?? "";
        profileImage = user["profileImage"] ?? "";
      });
    }
  }
  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        date.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> pickFromTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        fromTime.text = pickedTime.format(context);
      });
    }
  }

  Future<void> pickToTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        toTime.text = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC5E3F4),
      body: Column(
        children: [
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xff284a79),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Booking Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),

              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 30,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: databaseMethods.getUserDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!.data() == null) {
                          return const Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
                                "assets/images/profile.png",
                              ),
                            ),
                          );
                        }

                        final user = snapshot.data!.data() as Map<String, dynamic>;
                        print(user);
                        customerName.text = user["name"] ?? "";
                        customerEmail.text = user["email"] ?? "";

                        return Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              user["profileImage"] ?? "",
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40.0),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Customer Name",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16.0, right: 16.0),
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        color: const Color(0xffececf8),
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: TextFormField(
                        controller: customerName,
                        readOnly: true,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),

                        decoration: const InputDecoration(
                           border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.black, // Hint text color
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Customer Email",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16.0, right: 16.0),
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        color: const Color(0xffececf8),
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: TextFormField(
                        readOnly: true,
                        controller: customerEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter service provider name";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Customer Email",
                          hintStyle: TextStyle(
                            color: Colors.black, // Hint text color
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    // Phone
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Available Date",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xffececf8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: date,
                        readOnly: true,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        onTap: pickDate,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select Date",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "From Time",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffececf8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  controller: fromTime,
                                  readOnly: true,
                                  onTap: pickFromTime,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "From",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: Icon(Icons.access_time),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "To Time",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffececf8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  controller: toTime,
                                  readOnly: true,
                                  onTap: pickToTime,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "To",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: Icon(Icons.access_time),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 180),

                    /// Book Now
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff284a79),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                           onPressed: () async {

                             await databaseMethods.bookService(
                               customerId: FirebaseAuth.instance.currentUser!.uid,
                               customerName: customerName.text,
                               customerEmail: customerEmail.text,

                               providerId: widget.services["providerId"]?.toString() ?? "",
                               providerName: widget.services["providerName"]?.toString() ?? "",
                               category: widget.services["category"]?.toString() ?? "",
                               serviceId: widget.services["id"]?.toString() ?? "",
                               hourlyCharge: widget.services["hourlyCharge"].toString()??"",
                               bookingDate: date.text,
                               fromTime: fromTime.text,
                               toTime: toTime.text,
                             );
                             showMessage("Booking Successful", Colors.green);
                           },

                        child: const Text(
                          "Confirm Booking",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
