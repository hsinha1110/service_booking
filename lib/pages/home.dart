import 'package:flutter/material.dart';
import 'package:servicebooking/pages/book_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                    Color.fromARGB(255, 255, 232, 235),
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
                            Text(
                              "Hello, maria",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                "assets/images/girl.jpg",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 90,
                                margin: const EdgeInsets.only(right: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(45),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Image.asset(
                                          services[index]["image"]!,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      services[index]["title"]!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xff284a79),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
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
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: popularServices.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final services = popularServices[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookPage(services: services),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            services["image"]!,
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
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    services["rating"]!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),

                              Text(
                                services["title"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "By ${services["name"]!}",
                                style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          94,
                                          172,
                                          202,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        services["price"]!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff284a79),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        "Book Now",
                                        style: TextStyle(color: Colors.white),
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
            ),
          ],
        ),
      ),
    );
  }
}
