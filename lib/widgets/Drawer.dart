import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_for_pole/screens/Declaration.dart';
import 'package:project_for_pole/screens/HomeScreen.dart';
import 'package:project_for_pole/screens/ManageTasks.dart';
import 'package:project_for_pole/screens/MyTasks.dart';
import 'package:project_for_pole/screens/UserProfile.dart';
import 'package:project_for_pole/screens/accounts.dart';
import 'Methodes.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  String userType="..";
  String username="..";
  String email="";
  Future getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var data;
    data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    setState(() {
      userType=data.data()!['userType'];
      username=data.data()!['username'];
      email=data.data()!['email'];
    });
  }
  void initState(){
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Drawer(
        child:
        Column(
          children: <Widget>[
            buildHeader(),
            ListTile(
              leading: Icon(Icons.home, color: Colors.black,),
              title: Text('Accueil', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.settings,color: Colors.black,),
              title: Text('Paramètre Compte', style: TextStyle(
                fontSize: 20,fontWeight: FontWeight.bold),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile())),
            ),
            if(userType=="admin")...[
              ListTile(
                leading: Icon(Icons.switch_account, color: Colors.black,),
                title: Text('Gérer les compte', style: TextStyle(
                  fontSize: 20,fontWeight: FontWeight.bold),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Accounts())),
              ),
            ]else if (userType=="client")...[
              ListTile(
                leading: Icon(Icons.report_problem, color: Colors.black,),
                title: Text('Déclarer Un Problème', style: TextStyle(
                  fontSize: 20,fontWeight: FontWeight.bold
                ),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Declaration())),
              ),
            ]else if ( (userType=="employe")||(userType=="chef"))...[
              ListTile(
                leading: Icon(Icons.file_present, color: Colors.black,),
                title: Text('Mes tâches', style: TextStyle(
                  fontSize: 20,fontWeight: FontWeight.bold
                ),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MyTasks())),
              ),
              if(userType=="chef")...[
                ListTile(
                  leading: Icon(Icons.task, color: Colors.black,),
                  title: Text('Gérer tâches', style: TextStyle(
                    fontSize: 20,fontWeight: FontWeight.bold
                  ),
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ManageTasks())),
                ),
              ]
            ] ,
            Divider(color: Colors.black38),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black,),
              title: Text('Déconnecter', style: TextStyle(
                fontSize: 18,fontWeight: FontWeight.bold),),
              onTap: () => logOut(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: 200,
              color: Color.fromRGBO(42, 159, 244, 1),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 60, //140
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.person_pin,size: 50),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                            SizedBox(height: 5), //5
                            Text(
                              email,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
class CustomShape extends CustomClipper<Path>{
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height-10);
    path.quadraticBezierTo(
        size.width/2, size.height,
        size.width, size.height-50);
    path.lineTo(size.width ,0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}