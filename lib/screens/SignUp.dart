import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_for_pole/screens/SignIn.dart';
import 'package:project_for_pole/widgets/CustomTextFormField.dart';
import 'HomeScreen.dart';
import '../widgets/Methodes.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String _username,_companyName,_userPost,_email,_phoneNumber,_password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String signUpType="client";
  bool isLoading = false;
  bool showPassword= true;
  @override

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: isLoading? Center(
          child: Container(
            height: size.height/20,
            width: size.width/10,
            child: CircularProgressIndicator(),
          ),
        )
            :SingleChildScrollView(
          child: Column(
            children: [
              top(),
              SizedBox(height: 40,),
              Container(
                margin: EdgeInsets.only(bottom: 24, right: 24, left: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            if (signUpType=="client")...[ _builCompanyName(),
                            SizedBox(height: 20,)],
                            _buildPost(),
                            SizedBox(height: 20,),
                            _buildName(),
                            SizedBox(height: 20,),
                            _buildEmail(),
                            SizedBox(height: 20,),
                            _buildPhoneNumber(),
                            SizedBox(height: 20,),
                            _buildPassword(),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
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
                              createAccount(signUpType=="client"?_companyName:"", _username, _userPost,
                                  _email,_password, _phoneNumber, signUpType).then((user) {
                                if (user != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomeScreen()));
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }).catchError((e){
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
                            },
                            child: Text(
                              "S'inscrire",
                              style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),
                            )),
                      ),
                      SizedBox(height: 10,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SignIn())),
                              child: Text(
                                "Vous avez déjà un compte? connexion",
                                style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5).copyWith(
                                    color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(signUpType=="client"?"Vous êtes un employé? ":"Vous êtes un client? ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: 5.0,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                if(signUpType=="client")
                                signUpType="employe";
                                else signUpType="client";
                                isLoading=true;
                              });
                              Future.delayed(Duration(seconds: 1),(){
                                setState(() {
                                  isLoading=false;
                                });
                              });
                            },
                            child: Text("S'inscrire",
                            style: TextStyle(
                              color: Color.fromRGBO(42, 159, 244, 1),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline
                            ),),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _builCompanyName() {
    return TextFormField(
      decoration: inputDecoration('Nom de la société', Icon(Icons.business_center_outlined)),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Nom de la société obligatoire';
        }
        return null;
      },
      onSaved: (String? value) {
        _companyName = value!;
      },
    );
  }

  Widget _buildName() {
    return TextFormField(
      decoration: inputDecoration("Nom d'utilisateur", Icon(Icons.person_outline,)),
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Nom d'utilisateur obligatoire";
        }
        return null;
      },
      onSaved: (String? value) {
        _username = value!;
      },
    );
  }

  Widget _buildPost() {
    return TextFormField(
      decoration: inputDecoration("Poste de l'utilisateur", Icon(Icons.badge_outlined)),
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Poste de l'utilisateur obligatoire";
        }
        return null;
      },
      onSaved: (String? value) {
        _userPost = value!;
      },
    );
  }


  Widget _buildEmail() {
    return TextFormField(
      decoration: inputDecoration("Email", Icon(Icons.email_outlined)),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Email obligatoire';
        }
        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }
        return null;
      },
      onSaved: (String? value) {
        _email = value!;
      },
    );
  }


  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: inputDecoration("Num Tel", Icon(Icons.phone_outlined,)),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Num Tel obligatoire';
        }
        return null;
      },
      onSaved: (String? value) {
        _phoneNumber = value!;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: passwordInputDecoration("Mot de passe", Icon(Icons.lock_outline)),
      keyboardType: TextInputType.visiblePassword,
      obscureText : showPassword?true:false,
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



  InputDecoration passwordInputDecoration(String labelText,Icon icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: icon,
      suffixIcon: IconButton(
        icon: Icon(showPassword?Icons.visibility:Icons.visibility_off),
        onPressed: (){
          setState(() {
            showPassword=!showPassword;
          });
        },
      ),
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

  Widget top(){
    return SizedBox(
      height: 180,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: 170,
              color: Color.fromRGBO(42, 159, 244, 1),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                      "Inscription",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
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
    path.lineTo(0.0, size.height-25);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width ,0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
