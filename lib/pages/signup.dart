import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:servicebooking/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  List<String> roles = ["Customer", "Service Provider"];
  String selectedRole = "Customer";
  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<String> uploadProfileImage() async {
    if (selectedImage == null) return "";

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("profileImages")
        .child(fileName);

    UploadTask uploadTask = ref.putFile(selectedImage!);

    TaskSnapshot snapshot = await uploadTask;

    String url = await snapshot.ref.getDownloadURL();

    print("Download URL => $url");

    return url;
  }

  Future<void> signUp() async {
    try {
      if (selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select profile image")),
        );
        return;
      }

      String imageUrl = await uploadProfileImage();

      await DatabaseMethods().signUp(
        name: name.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
        role: selectedRole,
        profileImage: imageUrl,
      );
      print("Image URL => $imageUrl");
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Signup failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF283793),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text("Camera"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        pickImage(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text("Gallery"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        pickImage(ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : null,
                        child: selectedImage == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextFormField(
                  controller: name,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF4C59A5),
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                    hintText: "Enter your name",
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF4C59A5),
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    hintText: "Enter your email",
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }

                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value.trim())) {
                      return "Please enter a valid email";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: password,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF4C59A5),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    hintText: "Enter your password",
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your password";
                    }

                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    value: selectedRole,

                    items: roles
                        .map(
                          (role) => DropdownMenuItem<String>(
                            value: role,
                            child: Text(
                              role,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 60,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4C59A5),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ),

                    dropdownStyleData: DropdownStyleData(
                      decoration: const BoxDecoration(color: Color(0xFF4C59A5)),
                    ),

                    menuItemStyleData: const MenuItemStyleData(
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  if (_formkey.currentState!.validate()) {
                    signUp();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Validation Successful")),
                    );
                  }
                },
                child: Center(
                  child: Container(
                    width: 150,
                    height: 55,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFf95f3b),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already User?",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      SizedBox(width: 5.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          " Login",
                          style: TextStyle(
                            color: Color(0xFFf95f3b),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
