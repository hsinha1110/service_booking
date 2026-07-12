import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:servicebooking/pages/login.dart';
import 'package:servicebooking/services/database.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  final TextEditingController name = TextEditingController();
  final TextEditingController charges = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController fromTime = TextEditingController();
  final TextEditingController toTime = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List<String> services = ["Cleaning", "Painting", "Laundry", "Repairing"];
  String selectedService = "Cleaning";

  String? id;
  File? selectedImage;
  List<XFile> selectedImages = [];

  Future<void> pickImages() async {
    final List<XFile> images = await _imagePicker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images);
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

  Future<List<String>> uploadImages() async {
    List<String> imageUrls = [];

    for (XFile image in selectedImages) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference reference = FirebaseStorage.instance
          .ref()
          .child("serviceImages")
          .child(fileName);

      UploadTask uploadTask = reference.putFile(File(image.path));

      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();

      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  Future<void> uploadService() async {
    try {
      List<String> imageUrls = await uploadImages();

      // Current provider details
      DocumentSnapshot userDoc = await databaseMethods.getUserDetails();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      final docRef = FirebaseFirestore.instance.collection("services").doc();

      await docRef.set({
        "serviceId": docRef.id,
        "providerId": FirebaseAuth.instance.currentUser!.uid,
        "providerName": userData["name"], 
        "providerProfileImage": userData["profileImage"],
        "hourlyCharge": charges.text.trim(),
        "category": selectedService,
        "description": desc.text.trim(),
        "imageUrls": imageUrls,
        "availableDate": date.text.trim(),
        "availableFromTime": fromTime.text.trim(),
        "availableFromToTime": toTime.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      showMessage("Service Added Successfully", Colors.green);

      name.clear();
      charges.clear();
      desc.clear();
      date.clear();
      fromTime.clear();
      toTime.clear();

      setState(() {
        selectedImages.clear();
        selectedService = services.first;
        selectedDate = null;
        selectedTime = null;
      });
    } catch (e) {
      showMessage(e.toString(), Colors.red);
    }
  }

  Future<void> getImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC5E3F4),
      body: Column(
        children: [
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Service Details",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red, size: 30),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);

                              await databaseMethods.logOut();

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                GestureDetector(
                                  onTap: pickImages,
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),

                                ...selectedImages.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  XFile image = entry.value;

                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                          File(image.path),
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      Positioned(
                                        right: 5,
                                        top: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedImages.removeAt(index);
                                            });
                                          },
                                          child: const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.close,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Service Provider Name",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          color: const Color(0xffececf8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          controller: name,
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
                            hintText: "Enter Service Provider Name",
                            hintStyle: TextStyle(
                              color: Colors.black, // Hint text color
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Enter Hourly Charge",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          color: const Color(0xffececf8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          controller: charges,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter hourly charges";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Hourly Charge",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Select Categories",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xffececf8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            menuMaxHeight: 200,
                            value: selectedService,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: services.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedService = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "So how you want to provide this Service?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          color: const Color(0xffececf8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          controller: desc,
                          maxLines: 4,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter short description";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write a Short Description",
                            hintStyle: TextStyle(
                              color: Colors.black,
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
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: GestureDetector(
                          onTap: () async {
                            if (selectedImages.isEmpty) {
                              showMessage(
                                "Please select at least one image",
                                Colors.red,
                              );
                              return;
                            }
                            if (name.text.trim().isEmpty) {
                              showMessage(
                                "Please enter service provider name",
                                Colors.red,
                              );
                              return;
                            }

                            if (charges.text.trim().isEmpty) {
                              showMessage(
                                "Please enter hourly charges",
                                Colors.red,
                              );
                              return;
                            }

                            if (desc.text.trim().isEmpty) {
                              showMessage(
                                "Please enter short description",
                                Colors.red,
                              );
                              return;
                            }
                            print("All fields are valid");
                            await uploadService();
                          },
                          child: Center(
                            child: Container(
                              width: 200,
                              height: 60,
                              margin: EdgeInsets.only(left: 16.0, right: 16.0),
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              decoration: BoxDecoration(
                                color: const Color(0xffC5E3F4),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
