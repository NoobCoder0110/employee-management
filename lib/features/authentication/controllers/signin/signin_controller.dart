import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../utils/logging/logging.dart';

class SigninController extends GetxController {
  final _firebase = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var logger = Logger();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      final userCredential = await _firebase.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      logger.i("Login success");

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('user')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        CLoggerHelper.error("User data not found!");
        await _firebase.signOut(); // Logout if no data
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      // Check if approved
      if (userData['approved'] == false) {
        CLoggerHelper.error("Your account is not approved yet.");
        await _firebase.signOut(); // Logout
        return;
      }

      // Navigate based on type
      String userType = userData['type'];
      if (userType == "admin") {
        Get.offAllNamed("/adminPage"); // Navigate to Admin Page
      } else if (userType == "empolyee") {
        Get.back();
      } else {
        CLoggerHelper.error("Unknown user type.");
        await _firebase.signOut();
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-in-use") {
        CLoggerHelper.error("This email is already registered.");
      } else if (error.code == "invalid-email") {
        CLoggerHelper.error("Invalid email format.");
      } else if (error.code == "wrong-password") {
        CLoggerHelper.error("Wrong password.");
      } else if (error.code == "user-not-found") {
        CLoggerHelper.error("No user found with this email.");
      } else {
        CLoggerHelper.error(error.message ?? "Authentication failed.");
      }
    } catch (e) {
      CLoggerHelper.error(e.toString());
    }
  }
}
