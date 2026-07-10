import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  final Map<String, String> services;

  const BookPage({super.key, required this.services});
  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {

  @override
  void initState() {
    super.initState();
    print("Services Data: ${widget.services}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 60.0, left: 20.0),
              padding: EdgeInsets.all(10.0),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff284a79),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(20),
            height: 300,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 197, 227, 244),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.services["title"]!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff284a79),
                        ),
                      ),
                      const SizedBox(height: 5),

                        Text(
                          widget.services["name"]!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff284a79),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final images = [
                              "assets/images/girl.jpg",
                              "assets/images/cleaning1.jpg",
                              "assets/images/cleaning2.jpg",
                            ];

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                images[index],
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:  Text(
                      widget.services["price"]!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 👇 Blue container ke niche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Our professional home cleaning service includes kitchen cleaning, "
                  "bathroom cleaning, floor mopping, dusting, and complete sanitization. "
                  "We use high-quality products to ensure your home stays clean and hygienic.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff284a79),
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(Icons.alarm, size: 30),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "10:00 AM",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff284a79),
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(Icons.calendar_month, size: 30),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "09-07-2026",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff284a79),
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 120),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xff284a79),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
