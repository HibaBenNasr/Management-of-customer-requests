import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/Methodes.dart';
import 'UserProfile.dart';

class ConfirmDeleteUser extends StatefulWidget {
  const ConfirmDeleteUser({Key? key}) : super(key: key);

  @override
  _ConfirmDeleteUserState createState() => _ConfirmDeleteUserState();
}

class _ConfirmDeleteUserState extends State<ConfirmDeleteUser> {
  late String _email,_password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userEmail="..";
  Future getData() async {
    User? user =  FirebaseAuth.instance.currentUser;
    var data;
    data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    setState(() {
      userEmail=data.data()!['email'];
    });
  }
  void initState(){
    getData();
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: isLoading? Center(
          child: Container(
            height: size.height/20,
            width: size.width/10,
            child: CircularProgressIndicator(),
          ),
        )
            :Center(
              child: Material(
          type: MaterialType.transparency,
                child: Container(
          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
          ),
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width*0.85,
                  child: SingleChildScrollView(
          child: Column(
                  children: [
                    Container(
                      width: size.width/1.3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Entrez votre email et mot de passe pour continuer",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 24, right: 24, left: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10),
                            _buildEmail(),
                            SizedBox(height: 20),
                            _buildPassword(),
                            SizedBox(height: 30),
                            GestureDetector(
                              child: Container(
                                height: size.height/14,
                                width: size.width/1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Supprimer",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();
                                showDialog(context: context,
                                    builder: (BuildContext context)=>CupertinoAlertDialog(
                                        title: Text("Confirmer"),
                                        content: Text("Êtes-vous sûr de supprimer le compte?"),
                                        actions: [
                                          CupertinoDialogAction(child: Text("Supprimer"),
                                            onPressed: (){
                                              deleteAccount(
                                                  context,
                                                  _email,
                                                  _password)
                                                  .catchError((e){
                                                showDialog(context: context,
                                                    builder: (BuildContext context)=>CupertinoAlertDialog(
                                                        title: Text("Erreur"),
                                                        content: Text(e.message),
                                                        actions: [
                                                          CupertinoDialogAction(child: Text("ok"),
                                                            onPressed: (){
                                                              Navigator.of(context).pop();
                                                            },)
                                                        ]
                                                    ));
                                              });//Send to API
                                            },),
                                          CupertinoDialogAction(child: Text("Annuler"),
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },)
                                        ]
                                    ));
                              },
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Annuler",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context,MaterialPageRoute(builder: (context)=> UserProfile()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
          ),
        ),
                ),
              ),
            ),
      ),
    );
  }
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email',
          prefixIcon: Icon(Icons.drafts)),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Email obligatoire';
        }
        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }
        if(value!=userEmail){
          return 'Email incorrect';
        }
        return null;
      },
      onSaved: (String? value) {
        _email = value!;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Mot de passe',
          prefixIcon: Icon(Icons.lock_outline)
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText : true,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Mot de passe obligatoire';
        }
        return null;
      },
      onSaved: (String? value) {
        _password = value!;
      },
    );
  }
}
