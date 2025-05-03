import 'package:flutter/material.dart';

class AdminBottomMenu extends StatefulWidget {
  const AdminBottomMenu({super.key});

  @override
  State<AdminBottomMenu> createState() => _AdminBottomMenuState();
}

class _AdminBottomMenuState extends State<AdminBottomMenu> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Home Page')),
    Center(child: Text('Explore Page')),
    Center(child: Text('Chats Page')),
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
