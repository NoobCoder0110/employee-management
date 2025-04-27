import 'package:employee_management/features/authentication/controllers/signup/signup_controller.dart';
import 'package:employee_management/features/authentication/screens/signup/signup.dart';
import 'package:employee_management/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectOrgScreen extends StatelessWidget {
  const SelectOrgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.put(SignupController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select Organization"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Enter Company Name"),
                onChanged: (value) {
                  signupController.searchText.value = value.toString();
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(
                  () {
                    if (signupController.isOrganizationLoading.value) {
                      return const Center(
                          child:
                              CircularProgressIndicator()); // Show loading spinner while fetching
                    } else {
                      var filterList =
                          signupController.companies.where((company) {
                        // Check if company name contains the search text (case-insensitive)
                        return company['name'].toLowerCase().contains(
                            signupController.searchText.value.toLowerCase());
                      }).toList();
                      if (filterList.isEmpty) {
                        return const Center(
                            child: Text(
                                "No Data Present")); // Display message if no data
                      } else {
                        // Filter the list based on searchText

                        return ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (context, index) {
                            var company = filterList[index];
                            return Obx(
                              () {
                                RxBool isSelected = (company['company-id'] ==
                                        signupController
                                            .selectedCompanyId.value)
                                    .obs;
                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        color: CColors.black,
                                      ),
                                      child: Image.network(
                                        fit: BoxFit.cover,
                                        company['logo'],
                                      ),
                                    ),
                                  ),
                                  title: Text(company['name']),
                                  tileColor: isSelected.value
                                      ? Colors.blue.shade100
                                      : null,
                                  selectedTileColor: Colors.blue.shade200,
                                  onTap: () {
                                    signupController.selectedCompanyId.value =
                                        company['company-id'];

                                    signupController.selectedCompanyImage
                                        .value = company['logo'];

                                    signupController.selectedCompanyName.value =
                                        company['name'];
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
              Obx(
                () {
                  return signupController.selectedCompanyId.value == 0
                      ? SizedBox.shrink()
                      : Column(
                          children: [
                            SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () {
                                  Get.to(() => SignupScreen());
                                },
                                child: Text("Select"))
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
