import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_management/features/authentication/models/org/org_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/local_storage/org_local_store.dart';
import '../../../authentication/screens/signin/signin.dart';

class AttendanceController extends GetxController {
  var isCheckedIn = false.obs;
  var isAttendanceMarkedForToday = false.obs;
  var checkInTime = "".obs;
  var checkOutTime = "".obs;

  Future<void> checkTodayAttendanceStatus(String orgId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    log("Getting attendance");

    final attendanceDoc = FirebaseFirestore.instance
        .collection('organizations')
        .doc(orgId)
        .collection('employees')
        .doc(uid)
        .collection('attendance')
        .doc(today);

    final doc = await attendanceDoc.get();

    if (doc.exists) {
      final data = doc.data()!;
      final hasCheckedIn = data['checkIn'] != null;
      final hasCheckedOut = data['checkOut'] != null;

      isCheckedIn.value = hasCheckedIn && !hasCheckedOut;
      isAttendanceMarkedForToday.value = hasCheckedIn && hasCheckedOut;

      // Extract and format check-in and check-out times
      if (hasCheckedIn) {
        Timestamp checkInTimestamp = data['checkIn'];
        DateTime checkInDateTime = checkInTimestamp.toDate();
        checkInTime.value = DateFormat('hh:mm a').format(checkInDateTime);
      } else {
        checkInTime.value = '';
      }

      if (hasCheckedOut) {
        Timestamp checkOutTimestamp = data['checkOut'];
        DateTime checkOutDateTime = checkOutTimestamp.toDate();
        checkOutTime.value = DateFormat('hh:mm a').format(checkOutDateTime);
      } else {
        checkOutTime.value = '';
      }

      log('Check In: ${checkInTime.value}');
      log('Check Out: ${checkOutTime.value}');
    } else {
      isCheckedIn.value = false;
      isAttendanceMarkedForToday.value = false;
      checkInTime.value = '';
      checkOutTime.value = '';
    }
  }

  Future<void> markAttendance(String orgId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final attendanceRef = FirebaseFirestore.instance
        .collection('organizations')
        .doc(orgId)
        .collection('employees')
        .doc(uid)
        .collection('attendance')
        .doc(today);

    final doc = await attendanceRef.get();

    OrgModel? orgData = await SharedPreferencesHelper.getOrganization();
    log('Lat: ${orgData?.orgLat}');
    log('Long: ${orgData?.orgLong}');
    log('Logo: ${orgData?.orgLogo}');
    log('Name: ${orgData?.orgName}');
    log("-----");

    if (!doc.exists) {
      // First time: check in
      await attendanceRef.set({
        'checkIn': FieldValue.serverTimestamp(),
        'checkOut': null,
      });
      isCheckedIn.value = true;
    } else if (doc.exists &&
        doc['checkIn'] != null &&
        doc['checkOut'] == null) {
      // Check out
      await attendanceRef.update({
        'checkOut': FieldValue.serverTimestamp(),
      });
      isCheckedIn.value = false;
      // ✅ Add a flag so the user can’t mark again
      isAttendanceMarkedForToday.value = true;
    } else {
      // Already checked in and out — do nothing
      Get.snackbar(
          "Attendance", "You've already completed today's attendance.");
      isCheckedIn.value = false;
      isAttendanceMarkedForToday.value = true;
    }
  }

  Future<void> logoutUser() async {
    // Clear the organization details when logging out
    await SharedPreferencesHelper.clearOrganization();
    await SharedPreferencesHelper.clearOrganization();

    // Perform Firebase logout
    await FirebaseAuth.instance.signOut();

    // Navigate to login screen or do any other action
    Get.offAll(SigninScreen());
  }
}
