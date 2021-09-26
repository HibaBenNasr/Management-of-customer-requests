import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AppBar.dart';
import 'Drawer.dart';
import 'Methodes.dart';

class ListUsers extends StatefulWidget {
  final String type;
  const ListUsers({Key? key, required this.type}) : super(key: key);
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  late String appBarTitle;
  String userType= ".. ";
  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.type=="client"){
        appBarTitle="Clients";
      }
      else if(widget.type=="employe"){
        appBarTitle="Employés";
      }
      else{
        appBarTitle="Chefs hiérarchique";
      }
    });
    final Stream<QuerySnapshot> users=FirebaseFirestore.instance.collection("users").where("userType", isEqualTo: widget.type).snapshots();
    return Scaffold(
      drawer: MainDrawer(),
      appBar: customAppBar(appBarTitle,true),
      body: StreamBuilder<QuerySnapshot>(
        stream: users ,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text("error");
          }
          if (snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          final data =snapshot.requireData;
          return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index){
                return Card(
                  color: Colors.transparent,
                  // margin: EdgeInsets.zero,
                  elevation: 0,
                  child: ListTile(
                    title: Text(widget.type=="client"?data.docs[index]['companyName']:data.docs[index]['userPost'],
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    subtitle: Text(data.docs[index]['username'],style: TextStyle(fontSize: 18),),
                    trailing: data.docs[index]['isBanned']?
                    Text("bannu"):Text(""),
                    leading: CircleAvatar(
                      backgroundColor: Color.fromRGBO(42, 159, 244, 5),
                      child: Icon(Icons.person,size: 40,color: Colors.white,),
                      radius: 30.0,
                    ),
                    onTap: (){
                      showDialogFunc(context,data.docs[index]['username'],data.docs[index]['userPost'],widget.type=="client"?data.docs[index]['companyName']:"",data.docs[index]['email'],data.docs[index]["phone"],data.docs[index]["userType"],data.docs[index].id,data.docs[index]['isBanned']);
                    },
                  ),
                );
                //return Text(data.docs[index]['username']);
              }
          );
        },
      ),
    );

  }

  showDialogFunc(context,username,userPost,companyName,email,phone,userType,userId,state){
    final size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15),
                width: size.width*0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text(userType=="client"?companyName:userType=="employe"?"Employé":"Chef", style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold,
                      ),),
                      SizedBox(height: 20),
                      Container(
                        width: size.width*0.6,
                          child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(text: "Nom d'utilisateur\n"),
                                TextSpan(text: username,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,)),
                              ]
                            ),
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(text: "Poste\n"),
                                  TextSpan(text: userPost,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,)),
                                ]
                            ),
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(text: "email\n"),
                                  TextSpan(text: email,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,)),
                                ]
                            ),
                          ),
                          SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(text: "Num Tél\n"),
                                  TextSpan(text: phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,)),
                                ]
                            ),
                          ),
                        ],
                      )),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: userType=="client"?MainAxisAlignment.center:MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width/3,
                            child: MaterialButton(onPressed: (){
                              Navigator.of(context).pop();
                              showDialog(context: context,
                                  builder: (BuildContext context)=>CupertinoAlertDialog(
                                      title: Text("Confirmer"),
                                      content: Text("bannir ce compte ?"),
                                      actions: [
                                        CupertinoDialogAction(child: Text("Confirmer"),
                                          onPressed: (){
                                            isBanned(userId,state);
                                            Navigator.of(context).pop();
                                          },),
                                        CupertinoDialogAction(child: Text("Annuler"),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },)
                                      ]
                                  ));
                            },
                              child: Text("Bannir",style: TextStyle(color: Colors.white)),
                              color:  Colors.red,
                            ),
                          ),
                          if (userType!="client") Container(
                            width: size.width/3,
                            child: MaterialButton(onPressed: (){
                              setUserType(userType,userId);
                              Navigator.of(context).pop();
                            },
                              child: Text(
                                  userType=="employe"?"Promu Chef":"Enlèver privilèges",style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,),
                              color:  Colors.blue,
                            ),
                          ) ,
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
