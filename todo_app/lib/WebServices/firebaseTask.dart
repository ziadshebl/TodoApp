
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils.dart' as utils;
import 'package:flutter/material.dart';

class FirebaseTaskHandler {
  final Firestore _db = Firestore.instance;

  FirebaseUser user;

  void addTask(String taskTitle, DateTime dueTo, BuildContext context)async{
    user  = await FirebaseAuth.instance.currentUser();
    if(taskTitle==null || dueTo==null){
      utils.showErrorDialog('Couldn\'t add task', 'Please add all data needed', context);
    }
    print(taskTitle + dueTo.toString());
    _db.collection("users").document(user.uid).collection("tasks").add({
      "taskTitle": taskTitle,
      "dateCreated": DateTime.now(),
      "dueTo":dueTo,
    });
  }
}