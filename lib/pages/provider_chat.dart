import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servicebooking/pages/bottom_nav.dart';
import 'package:servicebooking/services/database.dart';

class ProviderChat extends StatefulWidget {
  final String bookingId;
  final String customerId;
  final String providerId;

  const ProviderChat({
    super.key,
    required this.bookingId,
    required this.customerId,
    required this.providerId,
  });

  @override
  State<ProviderChat> createState() => _ProviderChatState();
}

class _ProviderChatState extends State<ProviderChat> {
  final TextEditingController messageController = TextEditingController();
  final DatabaseMethods databaseMethods = DatabaseMethods();
  @override
  void initState() {
    super.initState();

    print("=========== PROVIDER CHAT SCREEN ===========");
    print(widget.bookingId);
    print(widget.customerId);
    print(widget.providerId);
  }

  Widget messageBubble({
    required bool isMe,
    required String message,
    required String time,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xff284a79) : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: isMe ? const Radius.circular(18) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const BottomNav()),
                        (route) => false,
                      );
                    },
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

                  const SizedBox(width: 15),

                  const CircleAvatar(radius: 24, child: Icon(Icons.person)),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Provider",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Online", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),

                  IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                ],
              ),
            ),

            /// Messages
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: databaseMethods.getMessages(widget.bookingId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("Start Conversation"));
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final data = messages[index].data();

                      bool isMe =
                          data["senderId"] ==
                          FirebaseAuth.instance.currentUser!.uid;

                      return messageBubble(
                        isMe: isMe,
                        message: data["message"],
                        time: "",
                      );
                    },
                  );
                },
              ),
            ),

            /// Bottom Input
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xff284a79),
                    child: IconButton(
                      onPressed: () async {
                        if (messageController.text.trim().isEmpty) return;

                        try {
                          await databaseMethods.sendMessage(
                            bookingId: widget.bookingId,
                            senderId: FirebaseAuth.instance.currentUser!.uid,
                            receiverId: FirebaseAuth.instance.currentUser!.uid ==
                                widget.customerId
                                ? widget.providerId
                                : widget.customerId,
                            message: messageController.text.trim(),
                          );

                          print("✅ Message Sent");
                          messageController.clear();
                        } catch (e) {
                          print("❌ Error: $e");
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                 ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
