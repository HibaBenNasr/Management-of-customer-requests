import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_for_pole/widgets/CommentsPage.dart';
import '../widgets/Drawer.dart';
import 'AppBar.dart';

class ViewClientsDeclarations extends StatefulWidget {
  const ViewClientsDeclarations({Key? key}) : super(key: key);

  @override
  _ViewClientsDeclarationsState createState() => _ViewClientsDeclarationsState();
}

class _ViewClientsDeclarationsState extends State<ViewClientsDeclarations> {
  final Stream<QuerySnapshot> rec=FirebaseFirestore.instance.collection("reclamation").orderBy("date",descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: MainDrawer(),
        appBar: customAppBar("Reclamations",true),
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7.0, bottom: 7.0,left: 15,right: 15),
                        child: ListView.builder(
                            itemCount: data.size,
                            itemBuilder: (context, index){
                              return
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
                              );
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
