import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'CommentsPage.dart';
import 'Methodes.dart';

class ViewNews extends StatefulWidget {
  final String userType;
  const ViewNews({Key? key,required this.userType}) : super(key: key);

  @override
  _ViewNewsState createState() => _ViewNewsState();
}

class _ViewNewsState extends State<ViewNews> {

  final Stream<QuerySnapshot> rec=FirebaseFirestore.instance.collection("news").orderBy("date",descending: true).snapshots();

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
                                                  Icon(Icons.new_releases_outlined,size: 32,),
                                                  SizedBox(width: 10,),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text (data.docs[index]['object'],
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
                                                  if(widget.userType=="chef")PopupMenuButton(
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
                                                      deleteNews(data.docs[index].id);
                                                      //  deleteNews(data.docs[index].id);
                                                    }
                                                  },
                                                    child: Icon(Icons.more_horiz,),
                                                  ),
                                                ],
                                              )),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(left: 3.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(data.docs[index]['details'],style: TextStyle(
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
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Row(
                                              //  decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
                                          //    mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.thumb_up_off_alt_rounded, ),
                                                  SizedBox(width: 4.0,),
                                                  Expanded(child: Text("J'aime ("+data.docs[index]['likesNum'].toString()+")",)),
                                                ],
                                              ),
                                            ),
                                            onTap: (){
                                              likesMethode(data.docs[index].id);
                                            },
                                          )),
                                          Expanded(child: InkWell(
                                            child: Row(
                                               // mainAxisAlignment: MainAxisAlignment.center,
                                               //   crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.comment, ),
                                                SizedBox(width: 4.0,),
                                                Expanded(child: Text("Commenter ("+data.docs[index]['commentNum'].toString()+")", )),
                                              ],
                                            ),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return CommentPage(postId: data.docs[index].id,commentType: "news",);
                                              }));
                                            },
                                          )),
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
    );
  }
}
