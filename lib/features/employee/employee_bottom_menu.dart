import 'package:employee_management/features/employee/screens/attendance/attendance.dart';
import 'package:flutter/material.dart';

class EmployeeBottomMenu extends StatefulWidget {
  const EmployeeBottomMenu({super.key});

  @override
  State<EmployeeBottomMenu> createState() => _EmployeeBottomMenuState();
}

class _EmployeeBottomMenuState extends State<EmployeeBottomMenu> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Home Page')),
    AttendanceScreen(),
    Center(child: Text('Chats Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
