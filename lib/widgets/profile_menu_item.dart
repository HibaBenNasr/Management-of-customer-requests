import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final void Function() press;
  final Icon i;
  const ProfileMenuItem({
    Key? key,
    required this.i,
    required this.title,
    required this.press,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: 20),
        child: SafeArea(
          child: Row(
            children: <Widget>[
              i,
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16, //16
                    color: Color(0xFF7286A5),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF7286A5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
