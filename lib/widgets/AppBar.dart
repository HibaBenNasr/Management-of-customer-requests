import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PreferredSize CustomAppBar(text,bool withDrawer){
  return PreferredSize(
    preferredSize: Size.fromHeight(100),
    child: AppBar(
      leading: withDrawer?Builder(builder: (context){
        return IconButton(onPressed: ()=> Scaffold.of(context).openDrawer(), icon: Icon(
            Icons.sort
        ));
      },):null,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Stack(
        children:[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              color: Color.fromRGBO(42, 159, 244, 1),
            ),
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    ),
  );
}


class CustomShape extends CustomClipper<Path>{
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height-50);
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