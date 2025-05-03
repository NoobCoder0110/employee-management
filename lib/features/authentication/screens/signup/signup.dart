import 'package:employee_management/features/authentication/controllers/signup/signup_controller.dart';
import 'package:employee_management/utils/formatters/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.find<SignupController>();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text("first name"),
              TextFormField(
                controller: signupController.firstNameController,
              ),
              Text("last name"),
              TextFormField(
                controller: signupController.lastNameController,
              ),
              Text("mobile"),
              TextFormField(
                controller: signupController.mobileController,
              ),
              Text("email"),
              TextFormField(
                controller: signupController.emailController,
              ),
              Text("dob"),
              TextFormField(
                controller: signupController.dobController,
                enabled: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    String formattedDate = CFormatter.formatDate(pickedDate);
                    signupController.dobController.text = formattedDate;
                  }
                },
              ),
              Text("address"),
              TextFormField(
                controller: signupController.addressController,
              ),
              DropdownMenu(
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: "employee", label: "Employee"),
                ],
                onSelected: (value) {
                  signupController.employeeTypeController.text =
                      value.toString();
                },
              ),
              Text("Password"),
              TextFormField(
                controller: signupController.passwordController,
              ),
              ElevatedButton(
                onPressed: () {
                  signupController.createUser();
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
