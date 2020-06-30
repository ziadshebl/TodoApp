import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'WebServices/firebaseTask.dart';
void showErrorDialog(String title, String content, BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
                child: Text('Ok'), onPressed: () => Navigator.of(ctx).pop())
          ],
        );
      });
}

bool addTaskDialog(BuildContext context) {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDueController = TextEditingController();
  DateTime dueTo;

  final FirebaseTaskHandler taskHandler = FirebaseTaskHandler();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text('Add Task'),
          children: <Widget>[
            Container(
              child: TextField(
                controller: _taskTitleController,
                decoration: InputDecoration(labelText: "Task Name"),
              ),
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextField(
                controller: _taskDueController,
                onTap: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now(), onConfirm: (date) {
                   _taskDueController.text=date.toString();
                   dueTo=date;
                  }, currentTime: DateTime.now());
                },
                decoration: InputDecoration(labelText: "Due to"),
              ),
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    "Add",
                    style: TextStyle(
                        color: Color.fromRGBO(127, 216, 88, 1),
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if(_taskTitleController.text.isNotEmpty && dueTo!=null){
                      taskHandler.addTask(_taskTitleController.text, dueTo, context);
                      Navigator.of(context).pop(true);
                    }
                  },
                )
              ],
            ))
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        );
      });
      
}

void showMessage(context,String message, bool warning) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        children: <Widget>[
          warning ? Icon(Icons.warning, color: Colors.white) : Icon(
              Icons.info, color: Colors.white),
          SizedBox(width: 5,),
          Text(message, style: TextStyle(color: Colors.white)),
        ],
      ),
      backgroundColor: Color.fromRGBO(127, 216, 88, 0.5),
      duration: new Duration(seconds: 3),
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: Colors.red,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }

