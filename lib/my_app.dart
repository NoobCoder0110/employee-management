import 'package:employee_management/features/admin/admin_bottom_menu.dart';
import 'package:employee_management/features/employee/employee_bottom_menu.dart';
import 'package:employee_management/splashcreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: CAppTheme.lightTheme,
      darkTheme: CAppTheme.darkTheme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while checking auth state
            return const SplashScreen();
          }

          if (snapshot.hasData) {
            // User is logged in, now check approval and type
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  // Show loading indicator while fetching user data
                  return const SplashScreen();
                }

                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  // If user data is not found, log them out
                  FirebaseAuth.instance.signOut();
                  return const SplashScreen();
                }

                var userData = userSnapshot.data!.data() as Map<String, dynamic>;

                // Check if user is approved
                if (userData['approved'] == false) {
                  FirebaseAuth.instance.signOut();
                  return const SplashScreen(); // User not approved
                }

                // Navigate based on user type
                String userType = userData['type'];
                if (userType == "admin") {
                  return const AdminBottomMenu(); // Navigate to Admin Page
                } else if (userType == "employee") {
                  return const EmployeeBottomMenu(); // Navigate to Employee Page
                } else {
                  FirebaseAuth.instance.signOut();
                  return const SplashScreen(); // Unknown user type
                }
              },
            );
          } else {
            // User is not logged in, show splash screen
            return const SplashScreen();
          }
        },
      ),
    );
  }
}

