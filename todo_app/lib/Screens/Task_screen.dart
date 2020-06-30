import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  static const routeName = '/Task_screen';
  TaskScreen();
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final taskInputController = TextEditingController();
  final taskDueController = TextEditingController();

  FirebaseUser user;
  String imageUrl;
  bool isUploading = false;
  String percentage;
  var taskId;
  DateTime dueTo;
  var taskContent;

  void getTaskData() async {
    user = await _auth.currentUser();

    var doc = _db
        .collection('users')
        .document(user.uid)
        .collection('tasks')
        .document(taskId);
    taskContent = await doc.get();
    setState(() {
      taskInputController.text = taskContent['taskTitle'];
      taskDueController.text = DateFormat.yMEd()
          .format(DateTime.parse(taskContent['dueTo'].toDate().toString()))
          .toString();
      dueTo = DateTime.parse(taskContent['dueTo'].toDate().toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map taskData = ModalRoute.of(context).settings.arguments as Map;
    taskId = taskData['taskId'];
    getTaskData();
    print(taskId);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: TextField(
              enabled: false,
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
              controller: taskInputController,
              decoration: InputDecoration(
                labelText: "Task Name",
                prefixIcon: Icon(Icons.filter_none),
              ),
            ),
            margin: EdgeInsets.fromLTRB(
                deviceSize.width * 0.1,
                deviceSize.height * 0.1,
                deviceSize.width * 0.1,
                deviceSize.height * 0.1),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: TextField(
              controller: taskDueController,
              onTap: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(), 
                    onConfirm: (date) {
                  if (date != null) {
                    print(date.toString());
                    taskDueController.text = date.toString();
                    dueTo = date;
                  }
                  
                }, currentTime: DateTime.now());
              },
              decoration: InputDecoration(
                  labelText: "Due to", suffixIcon: Icon(Icons.calendar_today)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Color.fromRGBO(127, 216, 88, 1),
                  ),
                ),
                onPressed: () {
                  taskContent.reference.updateData(<String, dynamic>{
                    "dueTo": dueTo,
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
