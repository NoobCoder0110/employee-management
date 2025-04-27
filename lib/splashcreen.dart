import 'package:employee_management/features/authentication/screens/signup/select_org.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/authentication/screens/signin/signin.dart';
import 'features/authentication/screens/signup/signup.dart';

class splashscreen extends StatelessWidget {
  const splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          ElevatedButton(
            onPressed: () {
              Get.to(() => SigninScreen());
            },
            child: Text("signin"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => SelectOrgScreen());
            },
            child: Text("signup"),
          ),
        ]),
      ),
    );
  }
}
