import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_for_pole/screens/HomeScreen.dart';
import 'package:project_for_pole/screens/SignIn.dart';
import 'package:project_for_pole/screens/UserProfile.dart';


Future<User?> createAccount(String companyName,String username,String userPost, String email, String password,String phone,String userType) async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = (await _auth.createUserWithEmailAndPassword(
        email: email, password: password)).user;
    if (user!= null){
      print("sign up sucessfull");
      user.updateDisplayName(username);

      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "uid": _auth.currentUser!.uid,
        "username": username,
        "email": email,
        "userType": userType,
        "userPost": userPost,
        "phone": phone,
        "isBanned":false
      });
      if(userType=="client"){
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
          "companyName": companyName,
        });
      }
      return user;
    }
    else{
      print("sign up failed");
      return user;
    }

}


Future createDeclaration(String object,String content,String date) async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

        await _firestore.collection('reclamation').add({
        "userId": _auth.currentUser!.uid,
        "object": object,
        "content": content,
          "date": date
      });
    }

Future createNews(String object,String details,String date) async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore.collection('news').add({
    "userId": _auth.currentUser!.uid,
    "object": object,
    "details": details,
    "date": date
  });
}

Future createTask(String object,String details,String date,String empId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore.collection('tasks').add({
    "empId": empId,
    "object": object,
    "details": details,
    "date": date,
    "done": false
  });
}

Future setIsDone(bool done,String taskId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore.collection('tasks').doc(taskId).update(
    {
      "done": !done
    }
  );
}

Future updateUser(username,phone,post,company,userId,userType) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('users').doc(userId).update(
      {
        "companyName": company,
        "username": username,
        "userPost": post,
        "phone": phone
      }
  );
  if(userType=="client")
    await _firestore.collection('users').doc(userId).update(
        {
          "companyName": company,
        }
    );

}

Future setUserType(String type,String userId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  if(type=="chef"){
    type="employe";
  }
  else{
    type="chef";
  }
  await _firestore.collection('users').doc(userId).update(
      {
        "userType": type
      }
  );
}

Future newsUpdate(object,details,newsId,date) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('news').doc(newsId).update(
      {
        "details": details,
        "object":object,
        "date":date
      }
  );
}

Future taskUpdate(object,details,taskId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('tasks').doc(taskId).update(
      {
        "details": details,
        "object":object,
      }
  );
}


Future deleteTask(String taskId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('tasks').doc(taskId).delete(
  );
}


Future deleteNews(String newsId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('news').doc(newsId).delete(
  );
}

Future deleteRec(String recId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('reclamation').doc(recId).delete(
  );
}


Future <User?> logIn(context,String email, String password)async{
  FirebaseAuth _auth = FirebaseAuth.instance;

    User? user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
    if (user != null){
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      return user;
    }

}



Future<User?> logOut(BuildContext context) async{
  FirebaseAuth _auth = FirebaseAuth.instance;
  try{
    await _auth.signOut().then((value){
      Navigator.push(context, MaterialPageRoute(builder: (_) => SignIn()));
    });
  }catch(e){
    Fluttertoast.showToast(msg: e.toString());
    print("error");
  }
}


void resetPassword(context, String email) async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  await _auth.sendPasswordResetEmail(email: email).then((value){
    Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile()));
  }).catchError((onError){
    Fluttertoast.showToast(msg: onError.toString());
  });
}


Future<User?> deleteAccount(context,email,password) async{
   FirebaseFirestore _firestore = FirebaseFirestore.instance;
   FirebaseAuth _auth= FirebaseAuth.instance;
  User? user =  _auth.currentUser;
  String userId=user!.uid;
  AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

  await user.reauthenticateWithCredential(credential).then((value){
    value.user!.delete().then((res) {
       _firestore.collection('users').doc(userId).delete();
      Navigator.push(context, MaterialPageRoute(builder: (_) => SignIn()));
    });
  });
}

Future isBanned(userID,bool state) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('users').doc(userID).update(
      {
        "isBanned":!state
      }
  );
}