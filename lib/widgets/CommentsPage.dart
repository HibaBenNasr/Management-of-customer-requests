import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Methodes.dart';

class CommentPage extends StatefulWidget {
  final String postId, commentType;
  const CommentPage({Key? key, required this.postId, required this.commentType}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState(postId,commentType);
}

class _CommentPageState extends State<CommentPage> {
  String idPost, type;
  _CommentPageState(this.idPost,this.type);
  ScrollController _scrollController=ScrollController();
  FirebaseAuth _auth= FirebaseAuth.instance;
  TextEditingController addComment=new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Commaintaires"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection(type).doc(idPost).collection("comments").orderBy("date").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasError){
                      return Text("error");
                    }
                    if (snapshot.connectionState==ConnectionState.waiting){
                      return Center();
                    }
                    final data =snapshot.requireData;
                    return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        controller: _scrollController,
                        itemCount: data.size,
                        itemBuilder: (context, index){
                          return
                            commentComponent(data.docs[index]['comment'], data.docs[index]['userName'],data.docs[index]['userId']== _auth.currentUser!.uid?true:false);
                        }
                    );
                  },
                )),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(child:
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: addComment,

                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                          hintText: "    Écrivez un commentaire...",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                    ),
                  )),
                  SizedBox(width: 5,),
                  CircleAvatar(
                    radius: 20,
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: (){
                        if(addComment.text.trim().isNotEmpty) {
                          if(type=="reclamation") {
                            createDeclarationComment(idPost, addComment.text);
                          }
                          else if(type=="news"){
                            createNewsComment(idPost, addComment.text);
                          }
                          else if(type=="tasks"){
                            createTasksComment(idPost, addComment.text);
                          }
                          addComment.clear();
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeOut);
                        }
                      },
                    ),

                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget commentComponent(comment,userName,sameUser){
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 20),
      child: Row(
        mainAxisAlignment: sameUser?MainAxisAlignment.end:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    userName,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        ),
                  ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  color: Colors.black.withOpacity(.3),
                  height: 1,
                  width: width / 1.5,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: width / 1.5,
                  child: Text(
                    comment,
                    style: TextStyle( fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
