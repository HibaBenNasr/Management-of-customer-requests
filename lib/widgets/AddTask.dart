import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_for_pole/widgets/CustomTextFormField.dart';
import 'package:project_for_pole/widgets/Methodes.dart';
import '../screens/ManageTasks.dart';
import 'AppBar.dart';
import 'Drawer.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late String _object;
  late String _message;
  var   selectedCurrency, selectedTypes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: CustomAppBar("Assigner des tâches",true),
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
              SizedBox(
                height: 10,
              ),
              Text(
                "Ajouter une tâche",
                style: TextStyle(
                  letterSpacing: 2.0,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 24, right: 24, left: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      _builObject(),
                      SizedBox(
                        height:20,
                      ),
                      _builDetails(),
                      SizedBox(
                        height: 20,
                      ),
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
                              var datetime=new DateTime.now();
                              String date=DateFormat('dd/MM/yyyy').format(datetime)+" "+DateFormat('kk:mm').format(datetime);
                              showEmpFunc(context,_object, _message,date);
                            },
                            child: Text(
                              "Envoyer",
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            )),
                      ),
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

  Widget _builObject() {
    return TextFormField(
      decoration: inputDecoration("Titre", Icon(Icons.title)),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Titre obligatoire';
        }
        return null;
      },
      onSaved: (String? value) {
        _object = value!;
      },
    );
  }

  Widget _builDetails() {
    return TextFormField(
      maxLines: 7,
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
      onSaved: (String? value) {
        _message = value!;
      },
    );
  }

  showEmpFunc(context,String object,String details,String date){
    final size = MediaQuery.of(context).size;
    final Stream<QuerySnapshot> chef=FirebaseFirestore.instance.collection("users").where("userType", isEqualTo: "chef").snapshots();
    final Stream<QuerySnapshot> emp=FirebaseFirestore.instance.collection("users").where("userType", isEqualTo: "employe").snapshots();

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
                width: size.width*0.9,
                height: 280,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Liste Employés",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                      StreamBuilder<QuerySnapshot>(
                        stream: emp ,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.hasError){
                            return Text("error");
                          }
                          if (snapshot.connectionState==ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator());
                          }
                          final data =snapshot.requireData;
                          return Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.size,
                                itemBuilder: (context, index){
                                  return Card(
                                    elevation: 0,
                                    child: ListTile(
                                      title: Text(data.docs[index]['userPost'],style: TextStyle(
                                          fontWeight: FontWeight.w700
                                      ),),
                                      subtitle: Text(data.docs[index]['username']),
                                      leading: CircleAvatar(
                                        child: Icon(Icons.account_circle_rounded),
                                      ),
                                      onTap: (){
                                        createTask(object, details,date,data.docs[index]['userId']);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ManageTasks()));
                                      },
                                    ),
                                  );
                                }
                            ),
                          );
                        },
                      ),
                      Text("Liste Chefs",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                      StreamBuilder<QuerySnapshot>(
                        stream: chef ,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.hasError){
                            return Text("error");
                          }
                          if (snapshot.connectionState==ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator());
                          }
                          final data =snapshot.requireData;
                          return Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.size,
                                itemBuilder: (context, index){
                                  return Card(
                                    elevation: 0,
                                    child: ListTile(
                                      title: Text(data.docs[index]['userPost'],style: TextStyle(
                                          fontWeight: FontWeight.w700
                                      ),),
                                        subtitle: Text(data.docs[index]['username']),
                                        leading: CircleAvatar(
                                          child: Icon(Icons.account_circle_rounded),
                                        ),
                                      onTap: (){
                                        createTask(object, details,date,data.docs[index]['userId']);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ManageTasks()));
                                      },
                                    ),
                                  );
                                }
                            ),
                          );
                        },
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
}

