import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_for_pole/widgets/AppBar.dart';
import 'package:project_for_pole/widgets/CustomTextFormField.dart';
import 'package:project_for_pole/widgets/Drawer.dart';
import 'package:project_for_pole/widgets/Methodes.dart';
import 'package:project_for_pole/widgets/ViewNews.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController delaisController = new TextEditingController();
  TextEditingController objectController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        appBar: customAppBar("Accueil",true),
        drawer: MainDrawer(),
        floatingActionButton: userType=="chef"?FloatingActionButton(
          onPressed: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) =>
            // AddNews()));
            showDialog(context: context, builder: (context){
              return Center(
                child: NewsAdd(),
              );
            });
          },
          child: Icon(Icons.add),
        ): null,
        body:
        ViewNews(userType: userType),
    );
  }
    Widget NewsAdd(){
      return Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width*0.85,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key:  _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: inputDecoration("Sujet",Icon(Icons.title)),
                      controller: objectController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Sujet obligatoire';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      maxLines: 6,
                      decoration: InputDecoration(
                        labelText: "Détails",
                        prefixIcon: Icon(Icons.speaker_notes),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: BorderSide(
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(color: Colors.blue,width: 2.0),
                        ),
                      ),
                      controller: delaisController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Détails obligatoire";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    MaterialButton(
                        color: Colors.blueGrey,
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          var datetime=new DateTime.now();
                          String date=DateFormat('dd/MM/yyyy').format(datetime)+" "+DateFormat('kk:mm').format(datetime);
                          _formKey.currentState!.save();
                          createNews(objectController.text,
                              delaisController.text,
                              date);
                          Navigator.of(context).pop();
                          objectController.clear();
                          delaisController.clear();
                          },
                        child: Text(
                          "Enregistrer",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
}
