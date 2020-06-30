import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils.dart' as utils;
import '../Screens/Intro_screen.dart';
import '../Screens/EditProfile_screen.dart';
import '../Screens/Task_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final fbm = FirebaseMessaging();
  FirebaseUser user;

  @override
  void initState() {
    getUid();
    super.initState();
  }


  void getUid() async {
    FirebaseUser currentUser = await auth.currentUser();
    setState(() {
      user = currentUser;
      fbm.subscribeToTopic(user.uid);
    });
  }


  

  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          child: Icon(Icons.add),
          onPressed: () {
            if(utils.addTaskDialog(context))
            {
              print('SHOULD SHOW');
              utils.showMessage(context, 'Task Added Successfully', false);
            }
          },
          backgroundColor: Color.fromRGBO(127, 216, 88, 1),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'LOGOUT',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  auth.signOut();
                  //Navigator.popUntil(context, (route) => false)
                  Navigator.of(context)
                      .pushReplacementNamed(IntroScreen.routeName);
                },
              ),
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person_outline,
                      color: Colors.blue,
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                },
              )
            ],
          ),
        ),
        body: Container(
            child: StreamBuilder(
          stream: _db
              .collection("users")
              .document(user.uid)
              .collection("tasks")
              .orderBy("dateCreated", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.isNotEmpty) {
                return ListView(
                    children: snapshot.data.documents.map((task) {
                  return Card(
                    child: ListTile(
                        leading: Container(
                            child: Image.asset('assets/TodoLogo.png')),
                        title: Text(task.data["taskTitle"]),
                        subtitle: Text('Due to: \n' +
                            DateFormat.yMEd().format(DateTime.parse(
                                    task.data["dueTo"].toDate().toString()))
                                .toString()+'\n'+ DateFormat.jm().format(DateTime.parse(
                                    task.data["dueTo"].toDate().toString()))
                                .toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit, color: Color.fromRGBO(127, 216, 88, 1)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(TaskScreen.routeName, arguments: {'taskId':task.documentID});
                              },
                            ),
                            IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _db
                                      .collection("users")
                                      .document(user.uid)
                                      .collection("tasks")
                                      .document(task.documentID)
                                      .delete().then((value) => {
                                        utils.showMessage(context, 'Task Deleted Successfully', false)
                                      });
                                }),
                          ],
                        )
                        ),
                  );
                }).toList());
              }
              return Container(
                child: Center(
                  child: Text('No Tasks Found'),
                ),
              );
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        )));
  }
}
