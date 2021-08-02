import 'package:flutter/material.dart';
import 'package:project_for_pole/widgets/AppBar.dart';
import 'package:project_for_pole/widgets/Drawer.dart';
import 'package:project_for_pole/widgets/ViewDeclaration.dart';
import 'package:project_for_pole/widgets/ViewTasks.dart';

import '../widgets/AddTask.dart';
class ManageTasks extends StatefulWidget {
  const ManageTasks({Key? key}) : super(key: key);

  @override
  _ManageTasksState createState() => _ManageTasksState();
}

class _ManageTasksState extends State<ManageTasks> {
  int _selectedIndex = 0;
  final tabs= [
    ViewDelaration(),
    ViewTasks(),
    AddTask(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _selectedIndex,
        backgroundColor: Color.fromRGBO(42, 159, 244, 1),
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'Reclamations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tâches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task),
            label: 'Assigner Tâche',
          ),
        ],
      ),
    );
  }
}
