import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AppBar.dart';
import 'CustomTextFormField.dart';
import 'Drawer.dart';
import 'Methodes.dart';

class ViewTasks extends StatefulWidget {
  const ViewTasks({Key? key}) : super(key: key);

  @override
  _ViewTasksState createState() => _ViewTasksState();
}

class _ViewTasksState extends State<ViewTasks> {
  TextEditingController delaisController = new TextEditingController();
  TextEditingController objectController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Stream<QuerySnapshot> rec=FirebaseFirestore.instance.collection("tasks").orderBy("date").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar("Liste des tâches",true),
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
                                        Expanded(
                                          child: Text(data.docs[index]['object'],style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),),
                                        ),
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
                                  delaisController.text = data.docs[index]['details'];
                                  objectController.text = data.docs[index]['object'];
                                showDialogFunc(context,data.docs[index]['object'],data.docs[index]['date'],data.docs[index]['details'],data.docs[index]['empId'],data.docs[index].id);
                              },
                            ),
                            Text (data.docs[index]['date'],
                              textAlign: TextAlign.center,style:
                              TextStyle(
                                  color: Colors.grey
                              ),),
                            Text(data.docs[index]['done']?"terminé": "non terminé",style: TextStyle(
                                fontSize: 14
                            ),),
                          ],
                        ),
                      ),
                    ),
                  );
                  //return Text(data.docs[index]['username']);
                }
            ),
          );
        },
      ),
    );
  }
  showDialogFunc(context,object,date,content,empId,taskId){
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
                width: MediaQuery.of(context).size.width*0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 12),
                    Text(object, style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 20),
                    Text(content),
                    SizedBox(height: 20),
                    Text(date),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        MaterialButton(onPressed: (){
                          Navigator.of(context).pop();
                          showDialog(context: context, builder: (context){
                            return Center(
                              child: modifyTask(context,taskId,object,content),
                            );
                          });
                        },
                          child: Text("Modifier",style: TextStyle(color: Colors.white)),
                          color:  Colors.green,
                        ),
                        SizedBox(width: 5,),
                        MaterialButton(onPressed: (){
                          deleteTask(taskId);
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
  Widget modifyTask(context,taskId,object,details){
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Material(
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
              padding: EdgeInsets.all(10),
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: MaterialButton(
                          elevation: 0,
                          color: Color.fromRGBO(42, 159, 244, 1),
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState!.save();
                            taskUpdate(objectController.text,
                                delaisController.text,
                                taskId);
                            Navigator.of(context).pop();},
                          child: Text(
                            "Enregistrer",
                            style: TextStyle(color: Colors.white,fontSize: 24),
                          )),
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
}

