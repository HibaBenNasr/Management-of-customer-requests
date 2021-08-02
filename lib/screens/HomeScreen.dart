import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_for_pole/screens/AddNews.dart';
import 'package:project_for_pole/widgets/AppBar.dart';
import 'package:project_for_pole/widgets/Drawer.dart';
import 'package:project_for_pole/widgets/Methodes.dart';
import 'package:project_for_pole/widgets/ViewNews.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    String userType="";
    bool isBanned=false;
  Future getData() async {
    User? user =  FirebaseAuth.instance.currentUser;
    var data;
      data = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();
    setState(() {
      userType=data.data()!['userType'];
      isBanned=data.data()!['isBanned'];
    });
  }
  void initState(){
    getData();
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return isBanned?
        Scaffold(
          body:
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                text : TextSpan(
                  style: TextStyle(fontSize: 50,color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: "Tu es "),
                    TextSpan(text: "Banni", style: TextStyle(fontWeight: FontWeight.bold)),
                  ]
                )
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () => logOut(context),
                  child: Text(
                    "Déconnecter",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ):
    Scaffold(
        appBar: CustomAppBar("Accueil",true),
        drawer: MainDrawer(),
        floatingActionButton: userType=="chef"?FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>
            AddNews()));
          },
          child: Icon(Icons.add),
        ): null,
        body:
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0,left: 15.0,right: 15.0),
          child:
          ViewNews(userType: userType),
        ),
    );
  }
}
