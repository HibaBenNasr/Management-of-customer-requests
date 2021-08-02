import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_for_pole/widgets/AppBar.dart';
import 'package:project_for_pole/widgets/Methodes.dart';

import 'UserProfile.dart';

class ModifyUserAccount extends StatefulWidget {
  const ModifyUserAccount({Key? key}) : super(key: key);

  @override
  _ModifyUserAccountState createState() => _ModifyUserAccountState();
}

class _ModifyUserAccountState extends State<ModifyUserAccount> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController userPostController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userType= ".. ";
  void getData() async {
    User? user =  FirebaseAuth.instance.currentUser;
    var data;
    data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    setState(() {
      userType=data.data()!['userType'];
      usernameController.text=data.data()!['username'];
      emailController.text=data.data()!['email'];
      phoneController.text=data.data()!['phone'];
      userPostController.text=data.data()!['userPost'];
      if(userType=="client")
      companyController.text=data.data()!['companyName'];
    });
  }
  void initState(){
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar("Modifier profil",false),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: 20,left: 20,right: 20  ),
            child: Form(
              key:  _formKey,
              child: Column(
                children: [
                  userType=="client"?
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Societé",Icon(Icons.business_center_outlined)),
                    controller: companyController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Nom de la société obligatoire';
                      }
                      return null;
                    },
                  ):SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Email",Icon(Icons.email_outlined)),
                    controller: emailController,
                    readOnly: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Nom d'utilisateur",Icon(Icons.person_outline,)),
                    controller: usernameController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Nom d'utilisateur obligatoire";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Tél",Icon(Icons.phone_outlined,)),
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Num Tél obligatoire';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Poste",Icon(Icons.badge_outlined)),
                    controller: userPostController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Poste obligatoire';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: MaterialButton(
                        elevation: 0,
                        color: Color.fromRGBO(42, 159, 244, 1),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          print(phoneController.text);
                          updateUser(usernameController.text,
                              phoneController.text,
                              userPostController.text,
                              companyController.text, FirebaseAuth.instance.currentUser!.uid, userType);
                          Navigator.push(context,MaterialPageRoute(builder: (context)=> UserProfile()));
                        },
                        child: Text(
                          "Enregistrer",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  InputDecoration inputDecoration(String labelText,Icon icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: icon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0.0),
        borderSide: BorderSide(
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(color: Colors.blue,width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(color: Colors.blue,width: 2.0),
      ),
      errorBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(color: Colors.red,width: 2.0),
      ),
    );
  }
}
