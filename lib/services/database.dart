import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> bookService({
    required String customerName,
    required String customerEmail,
    required String customerId,
    required String providerId,
    required String providerName,
    required String category,
    required String serviceId,
    required String bookingDate,
    required String fromTime,
    required String toTime,
    required String hourlyCharge,
    required String providerProfileImage
  }) async {
    await _firestore.collection("bookings").add({
      "customerId": customerId,
      "customerName": customerName,
      "customerEmail": customerEmail,
      "providerId": providerId,
      "providerName": providerName,
      "providerProfileImage": providerProfileImage,
      "serviceId": serviceId,
      "category": category,
      "hourlyCharge": hourlyCharge,
      "bookingDate": bookingDate,
      "fromTime": fromTime,
      "toTime": toTime,
      "status": "Pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCustomerBookings() async {
    String uid = _auth.currentUser!.uid;

    print("Current UID => $uid");

    return await _firestore
        .collection("bookings")
        .where("customerId", isEqualTo: uid)
        .get();
  }
  Future<QuerySnapshot<Map<String, dynamic>>> getProviderBookings() async {
    String uid = _auth.currentUser!.uid;

    return await _firestore
        .collection("bookings")
        .where("providerId", isEqualTo: uid)
        .get();
  }
  Future<void> acceptBooking(String bookingId) async {
    await _firestore.collection("bookings").doc(bookingId).update({
      "status": "Accepted",
    });
  }

  Future<void> rejectBooking(String bookingId) async {
    await _firestore.collection("bookings").doc(bookingId).update({
      "status": "Rejected",
    });
  }
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    required String profileImage,
  }) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection("users").doc(userCredential.user!.uid).set({
      "uid": userCredential.user!.uid,
      "name": name,
      "email": email,
      "role": role,
      "profileImage": profileImage,
      "createdAt": FieldValue.serverTimestamp(),
    });

    return userCredential;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCategoryServices(
    String category,
  ) async {
    return await _firestore
        .collection("services")
        .where("category", isEqualTo: category)
        .get();
  }

  Future<DocumentSnapshot> getUserDetails() async {
    String uid = _auth.currentUser!.uid;
    return await _firestore.collection("users").doc(uid).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getServiceDetails() async {
    return await _firestore.collection("services").get();
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
