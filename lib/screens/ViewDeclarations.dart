import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_for_pole/widgets/CommentsPage.dart';
import 'package:project_for_pole/widgets/Methodes.dart';

import '../widgets/Drawer.dart';

class ViewDeclarations extends StatefulWidget {
  const ViewDeclarations({Key? key}) : super(key: key);

  @override
  _ViewDeclarationsState createState() => _ViewDeclarationsState();
}

class _ViewDeclarationsState extends State<ViewDeclarations> {
  FirebaseAuth _auth= FirebaseAuth.instance;
  final Stream<QuerySnapshot> rec=FirebaseFirestore.instance.collection("reclamation").orderBy("date",descending: true).snapshots();
  String username=" ";
  Future getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var data;
    data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    setState(() {
      username=data.data()!['username'];
    });
  }
  void initState(){
    getData();
    super.initState();
  }
  TextEditingController text=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: MainDrawer(),
        appBar: AppBar(title: Text("Mes reclamations"),),
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
            return SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ListTile(
                              title: TextFormField(
                                controller: text,
                                maxLines: 7,
                                minLines: 1,
                                decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 9),
                                hintText: "Écrivez ici ... ",
                                hintStyle: TextStyle(
                                  fontSize: 18
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                )
                              ),),

                            ),
                          ),
                          Row(
                            children: [
                              Expanded(child:
                              InkWell(
                                onTap: (){
                                  if(text.text.trim().isNotEmpty) {
                                    var datetime = new DateTime.now();
                                    String date = DateFormat('dd/MM/yyyy')
                                            .format(datetime) +
                                        " " +
                                        DateFormat('kk:mm').format(datetime);
                                    createDeclaration(text.text, date,username);
                                  }
                                  text.clear();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child:
                                  Text("Envoyer",textAlign: TextAlign.center,style: TextStyle(
                                    color: Colors.blue, fontSize: 17, fontWeight: FontWeight.bold
                                  ),),),
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(height: 5,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7.0, bottom: 7.0,left: 15,right: 15),
                        child: ListView.builder(
                            itemCount: data.size,
                            itemBuilder: (context, index){
                              return data.docs[index]['userId']== _auth.currentUser!.uid?
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Card(
                                  shape: Border.all(color: Colors.black, width: 0.6),
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Container(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.supervised_user_circle,size: 32,),
                                                    SizedBox(width: 10,),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text (data.docs[index]['clientName'],
                                                            style:
                                                            TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18
                                                            ),),
                                                          Text (data.docs[index]['date'],
                                                            style:
                                                            TextStyle(
                                                                color: Colors.grey
                                                            ),),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuButton(
                                                      itemBuilder: (context){
                                                        return[
                                                          PopupMenuItem<String>(
                                                              value: "delete",
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                    child: Icon(Icons.delete_forever_outlined,),
                                                                  ),
                                                                  Text("Supprimer",style: TextStyle(
                                                                      fontSize: 17
                                                                  ),),
                                                                ],
                                                              )
                                                          )];
                                                      },onSelected: (value){
                                                      if (value=="delete"){
                                                        deleteRec(data.docs[index].id);
                                                      //  deleteNews(data.docs[index].id);
                                                      }
                                                    },
                                                      child: Icon(Icons.more_horiz,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(left: 3.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(data.docs[index]['content'],style: TextStyle(
                                                    color: Colors.black, fontSize: 16
                                                ),),
                                              ],
                                            ),
                                          ),
                                          isThreeLine: true,
                                        ),
                                        Divider(color: Colors.grey.withOpacity(0.5),),
                                        Row(
                                          children: [
                                            Expanded(child: InkWell(
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                //  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.comment, ),
                                                    SizedBox(width: 4.0,),
                                                    Text("Commentaires("+data.docs[index]['commentNum'].toString()+")", textAlign: TextAlign.center,),
                                                  ],
                                                ),
                                              ),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                              //   return CommentsPage(recId: data.docs[index].id);
                                                 return CommentPage(postId: data.docs[index].id,commentType: "reclamation",);
                                                }));
                                              },
                                            ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ): Center();
                            }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
