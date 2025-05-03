import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_management/utils/logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class SignupController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _firebase = FirebaseAuth.instance;
  var logger = Logger();
  RxList<DocumentSnapshot> companies = RxList([]);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var mobileController = TextEditingController();
  var dobController = TextEditingController();
  var addressController = TextEditingController();
  var employeeTypeController = TextEditingController();
  var isOrganizationLoading = false.obs;
  RxString errorMessage = "".obs;
  RxString searchText = "".obs;
  RxString selectedCompanyId = "".obs;
  RxString selectedCompanyName = "".obs;
  RxString selectedCompanyImage = "".obs;

  Future<void> getCompaniesByName() async {
    try {
      isOrganizationLoading.value = true;
      errorMessage.value = "";

      CollectionReference organizations =
          _firestore.collection("organizations");

      QuerySnapshot querySnapshot = await organizations.get();
      // QuerySnapshot querySnapshot =
      //     await organizations.where("name", isEqualTo: companyName).get();

      if (querySnapshot.docs.isNotEmpty) {
        companies.value = querySnapshot.docs;
        log(companies.length.toString());
      } else {
        errorMessage.value = "No companies found!";
      }
    } catch (e) {
      log(e.toString());
      errorMessage.value = "Error: $e";
    } finally {
      isOrganizationLoading.value = false;
    }
  }

  Future<void> createUser() async {
    try {
      final userCredential = await _firebase.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      logger.i(userCredential);

      await _firestore.collection("user").doc(userCredential.user!.uid).set({
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "mobile": mobileController.text,
        "dob": dobController.text,
        "address": addressController.text,
        "profileImage": "",
        "approved": false,
        "approvedby": "",
        "type": employeeTypeController.text,
        "orgid": selectedCompanyId.value,
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-in-use") {
      } else if (error.code == "invalid-email") {
      } else {
        CLoggerHelper.error(error.message ?? "Authentication failed.");
      }
      CLoggerHelper.error(error.message ?? "Authentication failed.");
    } finally {}
  }

  @override
  void onInit() {
    getCompaniesByName();
    super.onInit();
  }
}
