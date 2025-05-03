import 'package:employee_management/features/employee/controllers/attendance.dart/attendance_controller.dart';
import 'package:employee_management/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_action/slide_action.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceController attendanceController =
      Get.put(AttendanceController());

  @override
  void initState() {
    attendanceController.checkTodayAttendanceStatus("5LrKOSi6qquELvCawhzv");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You can mark you attendance here !",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            ),
            SizedBox(height: 20),
            Obx(() {
              final checkIn = attendanceController.checkInTime.value.isNotEmpty
                  ? attendanceController.checkInTime.value
                  : "--:-- --";

              final checkOut =
                  attendanceController.checkOutTime.value.isNotEmpty
                      ? attendanceController.checkOutTime.value
                      : "--:-- --";

              return Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: CColors.grey,
                      blurRadius: 1,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Check In",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          checkIn,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Check Out",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          checkOut,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            Text("11"),
            Obx(() {
              return attendanceController.isAttendanceMarkedForToday.value
                  ? const Text("Attendance already marked for today")
                  : SlideAction(
                      trackBuilder: (context, currentState) {
                        return Center(
                          child: Container(
                            color: CColors.white,
                            child: Obx(() => Text(
                                  attendanceController.isCheckedIn.value
                                      ? "Check Out"
                                      : "Check In",
                                )),
                          ),
                        );
                      },
                      thumbBuilder: (context, state) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: state.isPerformingAction
                                ? const CupertinoActivityIndicator(
                                    color: Colors.white)
                                : const Icon(Icons.chevron_right,
                                    color: Colors.white),
                          ),
                        );
                      },
                      action: () => attendanceController
                          .markAttendance("5LrKOSi6qquELvCawhzv"),
                    );
            }),
            ElevatedButton(
                onPressed: () {
                  attendanceController.logoutUser();
                },
                child: Text("logout"))
          ],
        ),
      ),
    );
  }
}
