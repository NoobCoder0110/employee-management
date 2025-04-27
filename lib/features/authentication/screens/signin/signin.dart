import 'package:employee_management/features/authentication/controllers/signin/signin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SigninController signinController = Get.put(SigninController());
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextFormField(
              controller: signinController.emailController,
            ),
            TextFormField(
              controller: signinController.passwordController,
            ),
            ElevatedButton(
                onPressed: () {
                  signinController.loginUser();
                },
                child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}
