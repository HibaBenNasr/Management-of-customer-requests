import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_for_pole/screens/HomeScreen.dart';
import 'package:project_for_pole/widgets/profile_menu_item.dart';
import '../widgets/Drawer.dart';
import 'ConfirmDeleteUser.dart';
import 'modifyUserAccount.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String username= "...";
  String email= "...";
  void getData() async {
    User? user =  FirebaseAuth.instance.currentUser;
    var data;
    data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    setState(() {
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
    return WillPopScope(
      onWillPop: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
        return Future.value(false);
      },
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
            leading: Builder(builder: (context){
              return IconButton(onPressed: ()=> Scaffold.of(context).openDrawer(), icon: Icon(
                  Icons.sort
              ));
            },),
            backgroundColor: Color.fromRGBO(42, 159, 244, 1),
            elevation: 0,
            title:  Text(
              "Paramètre Compte",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          centerTitle: true,
          ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              top(),
              SizedBox(height: 10), //20
              ProfileMenuItem(
                i: Icon(
                  Icons.account_circle,
                  size: 20,
                  color: Color(0xFF7286A5),
                ),
                title: "Modifier profil",
                press: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> ModifyUserAccount()));
                },
              ),
              ProfileMenuItem(
                i: Icon(
                  Icons.lock_clock,
                  size: 20,
                  color: Color(0xFF7286A5),
                ),
                title: "Réinitialiser le mot de passe",
                press: () {},
              ),
              ProfileMenuItem(
                i: Icon(
                  Icons.delete_forever,
                  size: 20,
                  color: Color(0xFF7286A5),
                ),
                title: "Supprimer compte",
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ConfirmDeleteUser()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget top(){
    return SizedBox(
      height: 220,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: 120,
              color: Color.fromRGBO(42, 159, 244, 1),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: 40,),
                  Container(
                    height: 120, //140
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/user.png"),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold// 22
                    ),
                  ),
                  SizedBox(height: 5), //5
                  Text(
                    email,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
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
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height-25);
    path.lineTo(size.width ,0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}