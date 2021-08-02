import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_for_pole/widgets/CustomTextFormField.dart';

import 'Methodes.dart';

class ViewNews extends StatefulWidget {
  final String userType;
  const ViewNews({Key? key, required this.userType}) : super(key: key);

  @override
  _ViewNewsState createState() => _ViewNewsState();
}

class _ViewNewsState extends State<ViewNews> {
  TextEditingController delaisController = new TextEditingController();
  TextEditingController objectController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Stream<QuerySnapshot> rec=FirebaseFirestore.instance.collection("news").orderBy("date",descending: true).snapshots();
  String date=".";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: rec ,
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Card(
                  shape: Border.all(color: Colors.black, width: 0.6),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Container(
                                child: Row(
                                  children: [
                                    Icon(Icons.new_releases_outlined,size: 18,),
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
                            child: Text(data.docs[index]['details'],style: TextStyle(
                              color: Colors.black
                            ),),
                          ),
                          isThreeLine: true,
                          onTap: (){
                            if(widget.userType=="chef") {
                              delaisController.text = data.docs[index]['details'];
                              objectController.text = data.docs[index]['object'];
                            }
                            showDialogFunc(context,data.docs[index]['object'],data.docs[index]['date'],data.docs[index]['details'],data.docs[index].id,widget.userType);
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
        );
      },
    );
  }
  showDialogFunc(context,object,date,content,newsId,userType){
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
                width: MediaQuery.of(context).size.width*0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(object, style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold,
                    ),
                        textAlign: TextAlign.center
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          child: Text(content,textAlign: TextAlign.start)),
                    ),
                    SizedBox(height: 20),
                    Text (date,
                      textAlign: TextAlign.center,style:
                      TextStyle(
                          color: Colors.grey
                      ),),
                    SizedBox(height: 10),
                    if (userType=="chef") Row(
                      children: [
                        MaterialButton(onPressed: (){
                          Navigator.of(context).pop();
                          showDialog(context: context, builder: (context){
                            return Center(
                              child: modifyNews(context,newsId,object,content),
                            );
                          });
                        },
                          child: Text("Modifier",style: TextStyle(color: Colors.white)),
                          color:  Colors.green,
                        ),
                        SizedBox(width: 5,),
                        MaterialButton(onPressed: (){
                          deleteNews(newsId);
                          Navigator.of(context).pop();
                        },
                          child: Text("Supprimer",style: TextStyle(color: Colors.white)),
                          color:  Colors.red,
                        ),
                      ],
                    ) ,
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget modifyNews(context,newsId,object,details){
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
                        newsUpdate(objectController.text,
                            delaisController.text,
                             newsId,date);
                        Navigator.of(context).pop();},
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

