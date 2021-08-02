import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_for_pole/screens/Opening.dart';
import 'package:project_for_pole/widgets/CustomTextFormField.dart';
import '../widgets/Methodes.dart';
import 'SignUp.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showPassword= true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
      return WillPopScope(
      onWillPop: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Opening()));
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: isLoading ? Center(
            child: Container(
              width: size.width /10,
              height: size.height /20,
              child: CircularProgressIndicator(),
            ),
          ) :SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                top(),
                SizedBox(height: 70,),
                Container(
                  margin: EdgeInsets.only(bottom: 24, right: 24, left: 24),
                  child: Form(
                    key:  _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildEmail(),
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

                                logIn(context,emailController.text,passwordController.text).then((user){
                                  if(user != null){
                                    setState(() {
                                      isLoading = true;
                                    });
                                  }
                                  else{
                                    setState(() {
                                      isLoading =false;
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
                                });
                              },
                              child: Text(
                                "Connecter",
                                style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),
                              )),
                        ),
                        SizedBox(height: 15,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignUp())),
                                child: Text(
                                  "Vous n'avez pas de compte ? S'inscrire",
                                  style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5).copyWith(
                                      color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
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
    );
  }


  Widget _buildEmail(){
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: inputDecoration("Email", Icon(Icons.email_outlined)),
      controller: emailController,
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
    );
  }

  Widget _buildPassword(){
   return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: "Mot de passe",
        prefixIcon: Icon(Icons.lock_outline),
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
      ),
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText : showPassword?true:false,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Mot de passe obligatoire";
        }
        return null;
      },
    );
  }

  Widget top(){
    return SizedBox(
      height: 200,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: 190,
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
                      "Connexion",
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

