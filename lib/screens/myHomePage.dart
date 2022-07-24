
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/screens/homePage.dart';
import 'package:todo_app_flutter/screens/searchTaskPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen": const HomePage(), "title": "Home Screen"},
    {"screen":  const SearchPage(), "title": "Search Page"}
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedScreenIndex]["title"]),
      ),
      body: _screens[_selectedScreenIndex]["screen"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Screen'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search Page")
        ],
      ),
    );
  }
}
