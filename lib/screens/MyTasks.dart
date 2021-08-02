import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_for_pole/widgets/AppBar.dart';
import 'package:project_for_pole/widgets/Drawer.dart';
import 'package:project_for_pole/widgets/Methodes.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({Key? key}) : super(key: key);

  @override
  _MyTasksState createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  FirebaseAuth _auth= FirebaseAuth.instance;

  final Stream<QuerySnapshot> tasks=FirebaseFirestore.instance.collection("tasks").orderBy("date").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Mes Tâches",true),
    drawer: MainDrawer(),
       body: StreamBuilder<QuerySnapshot>(
          stream: tasks ,
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
                    return data.docs[index]['empId']== _auth.currentUser!.uid?
                    Padding(
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
                                  showDialogFunc(context,data.docs[index]['object'],data.docs[index]['date'],data.docs[index]['details'],data.docs[index]['done'],data.docs[index].id);
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
                    ): Center();
                    //return Text(data.docs[index]['username']);
                  }
              ),
            );
          },
        ),
    );
  }
}


showDialogFunc(context,object,date,content,isDone, String taskId){
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
              width: size.width*0.7,
              child: SingleChildScrollView(
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
                    MaterialButton(onPressed: (){
                      setIsDone(isDone,taskId);
                      Navigator.of(context).pop();
                    },
                      child: Text(isDone? "Marquer comme non terminé":"Marquer comme terminé" ,
                          style: TextStyle(color: Colors.white),textAlign: TextAlign.center,) ,
                      color:  Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
  );
}