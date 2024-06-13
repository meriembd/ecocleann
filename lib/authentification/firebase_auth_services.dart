import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password,
      String fullName, String phone, String adresse, String role) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'phone': phone,
          'adresse': adresse,
          'role': role,
          'email': email,
        });
      }
      return user;
    } catch (e) {
      print("An error occurred during sign up: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("An error occurred during sign in: $e");
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("An error occurred while resetting password: $e");
    }
  }

  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc['role'];
      } else {
        throw Exception('User role not found');
      }
    } catch (e) {
      print("An error occurred while fetching user role: $e");
      return 'Unknown';
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      print("An error occurred while fetching user data: $e");
      return null;
    }
  }

  Future<void> saveWasteSelection(String uid, String wasteType) async {
    try {
      await _firestore.collection('wasteSelections').add({
        'userId': uid,
        'wasteType': wasteType,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("An error occurred while saving waste selection: $e");
    }
  }
}
