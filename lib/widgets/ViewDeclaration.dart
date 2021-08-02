import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AppBar.dart';
import 'Drawer.dart';
import 'Methodes.dart';

class ViewDelaration extends StatefulWidget {
  const ViewDelaration({Key? key}) : super(key: key);

  @override
  _ViewDelarationState createState() => _ViewDelarationState();
}

class _ViewDelarationState extends State<ViewDelaration> {
  final Stream<QuerySnapshot> rec=FirebaseFirestore.instance.collection("reclamation").orderBy("date",descending: true).snapshots();
  String userId=".";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar("Reclamations",true),
      body: StreamBuilder<QuerySnapshot>(
        stream: rec ,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text("error");
          }
          if (snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          final data =snapshot.requireData;
          return Padding(
            padding: const EdgeInsets.only(bottom: 15.0,left: 15.0,right: 15.0),
            child: ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Card(
                      shape: Border.all(color: Colors.black, width: 0.6),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.article_outlined,size: 18,),
                                        SizedBox(width: 10,),
                                        Text(data.docs[index]['object'],style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                        ),),
                                      ],
                                    )),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Text(data.docs[index]['content'],style: TextStyle(
                                    color: Colors.black
                                ),),
                              ),
                              isThreeLine: true,
                              onTap: (){
                                showDialogFunc(context,data.docs[index]['object'],data.docs[index]['date'],data.docs[index]['content'],data.docs[index]['userId'],data.docs[index].id);
                              },
                            ),
                            Text (data.docs[index]['date'],
                              textAlign: TextAlign.center,style:
                              TextStyle(
                                  color: Colors.grey
                              ),),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          );
        },
      ),
    );
  }
}

showDialogFunc(context,object,date,content,userId,recId){
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
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width*0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 12),
                  Text(object, style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold,
                  ),
                    textAlign: TextAlign.center,),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(content),
                  ),
                  SizedBox(height: 20),
                  Text("date: $date",textAlign: TextAlign.center,),
                  SizedBox(height: 10),
                  MaterialButton(onPressed: (){
                    deleteRec(recId);
                    Navigator.of(context).pop();
                  },
                    child: Text("Supprimer",style: TextStyle(color: Colors.white)),
                    color:  Colors.red,
                  ),
                ],
              ),
            ),
          ),
        );
      }
  );
}