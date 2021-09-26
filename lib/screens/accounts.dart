import 'package:flutter/material.dart';
import 'package:project_for_pole/widgets/ListUsers.dart';


class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  int _selectedIndex = 0;
  final tabs= [
  ListUsers(type: "client"),
    ListUsers(type: "employe"),
    ListUsers(type: "chef"),
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

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline,),
            label: 'Employés',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline,),
            label: 'Chefs',
          ),
        ],

      ),
    );
  }

}
