import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_for_pole/screens/SignIn.dart';
import 'package:project_for_pole/screens/SignUp.dart';


class Opening extends StatefulWidget {
  const Opening({Key? key}) : super(key: key);

  @override
  _OpeningState createState() => _OpeningState();
}

class _OpeningState extends State<Opening> {
  @override
  DateTime timeBackPressed = DateTime.now();

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference>=Duration(seconds: 2);
          timeBackPressed = DateTime.now();

          if(isExitWarning){
            Fluttertoast.showToast(msg: "Appuyez à nouveau pour quitter",fontSize: 18);
            return false;
          }
          else{
            Fluttertoast.cancel();
            return true;
          }
        },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              top(),
              SizedBox(height: 40,),
              Container(
                margin: EdgeInsets.only(bottom: 24, right: 24, left: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: MaterialButton(
                          elevation: 0,
                          color: Color.fromRGBO(42, 159, 244, 1),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SignIn()));
                          },
                          child: Text(
                            "Connexion",
                            style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),
                          )),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: MaterialButton(
                          elevation: 0,
                          color: Color.fromRGBO(109, 109, 109,1),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SignUp()));
                          },
                          child: Text(
                            "Inscription",
                            style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget top(){
    return SizedBox(
      height: 400,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: 390,
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
                      "Bienvenue",
                      style: TextStyle(
                        fontSize: 62,
                       fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: "Roboto"
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
    path.lineTo(0.0, size.height-50);
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
