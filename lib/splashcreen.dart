
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class splashscreen extends StatelessWidget {
  const splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            // Get.to(() => SigninScreen());
          },
          child: Text("signin"),
        ),
        ElevatedButton(
          onPressed: () {
            // Get.to(() => SignupScreen());

          },
          child: Text("signup"),
        ),
      ]),
    );
  }
}
