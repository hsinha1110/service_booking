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
