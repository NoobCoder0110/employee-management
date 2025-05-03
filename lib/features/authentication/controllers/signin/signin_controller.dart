import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../utils/local_storage/org_local_store.dart';
import '../../../admin/admin_bottom_menu.dart';
import '../../../employee/employee_bottom_menu.dart';
import '../../models/org/org_model.dart'; // Adjust the path

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

      DocumentSnapshot userDoc = await _firestore
          .collection('user')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        logger.e("User data not found!");
        await _firebase.signOut();
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      // Approved check
      if (userData['approved'] == false) {
        logger.e("Your account is not approved yet.");
        await _firebase.signOut();
        return;
      }

      DocumentSnapshot orgDoc = await _firestore
          .collection('organizations')
          .doc(userData['orgid']) // <-- CORRECTED LINE
          .get();

      final orgMap = orgDoc.data() as Map<String, dynamic>;
      logger.i("Organization data: $orgMap");

      final org = OrgModel(
        orgName: orgMap['name'] ?? "Unknown",
        orgLogo: orgMap['logo'] ?? "",
        orgLat: (orgMap['lat'] as num?)?.toDouble() ?? 0.0,
        orgLong: (orgMap['log'] as num?)?.toDouble() ?? 0.0,
      );

      await SharedPreferencesHelper.saveOrganization(org);

      // Navigate by user type
      String userType = userData['type'];
      if (userType == "admin") {
        Get.offAll(() => AdminBottomMenu());
      } else if (userType == "employee") {
        Get.offAll(() => EmployeeBottomMenu());
      } else {
        logger.e("Unknown user type.");
        await _firebase.signOut();
      }
    } on FirebaseAuthException catch (error) {
      _handleFirebaseAuthError(error);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void _handleFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case "email-already-in-use":
        logger.e("This email is already registered.");
        break;
      case "invalid-email":
        logger.e("Invalid email format.");
        break;
      case "wrong-password":
        logger.e("Wrong password.");
        break;
      case "user-not-found":
        logger.e("No user found with this email.");
        break;
      default:
        logger.e(error.message ?? "Authentication failed.");
        break;
    }
  }
}
