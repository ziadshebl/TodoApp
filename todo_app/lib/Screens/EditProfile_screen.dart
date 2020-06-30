import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:math';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/editProfile_screen';
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final nameInputController = TextEditingController();

  FirebaseUser user;
  String imageUrl;
  bool isUploading = false;
  String percentage;
  var userContent;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    user = await _auth.currentUser();

    print(user.uid);
    var doc = _db.collection('users').document(user.uid);
    print(user.uid);
    await doc.get().then((user) {
      setState(() {
        userContent=user;
        imageUrl = userContent.data['photoUrl'];
        nameInputController.text = userContent.data['name'];
        print(userContent.data.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    print([
      deviceSize.width * 0.4,
      deviceSize.height * 0.4,
    ].reduce(min));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, deviceSize.height * 0.1, 0, deviceSize.height * 0.01),
              child: CircleAvatar(
                radius: [
                  deviceSize.width * 0.35,
                  deviceSize.height * 0.35,
                ].reduce(min),
                backgroundImage: imageUrl == null
                    ? AssetImage('assets/no-image.png')
                    : NetworkImage(imageUrl),
                backgroundColor: Colors.transparent,
              ),
            ),
            isUploading == true
                ? Container(child: Text(percentage + '%'))
                : Container(),
            Container(
              width: deviceSize.width * 0.4,
              child: FlatButton(
                onPressed: () async {
                  try {
                    File file = await FilePicker.getFile();
                    String fileName = path.basename(file.path);
                    StorageUploadTask _uploadTask = _storage
                        .ref()
                        .child("images")
                        .child(fileName)
                        .putFile(file);

                    _uploadTask.events.listen((e) {
                      if (e.type == StorageTaskEventType.success) {
                        e.snapshot.ref.getDownloadURL().then((url) {
                          setState(() {
                            imageUrl = url;
                            print(url);
                            isUploading = false;
                          });
                        });
                      } else if (e.type == StorageTaskEventType.progress) {
                        setState(() {
                          isUploading = true;
                          percentage = ((e.snapshot.bytesTransferred /
                                      e.snapshot.totalByteCount) *
                                  100)
                              .toStringAsFixed(0);
                        });
                        print(((e.snapshot.bytesTransferred /
                                    e.snapshot.totalByteCount) *
                                100)
                            .toString());
                      }
                    });
                  } catch (e) {}
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.image,
                      color: Colors.blue,
                    ),
                    Text(
                      'Edit Image',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: nameInputController,
                decoration: InputDecoration(
                    labelText: "Name", prefixIcon: Icon(Icons.person)),
              ),
              margin: EdgeInsets.fromLTRB(
                  deviceSize.width * 0.1,
                  deviceSize.height * 0.1,
                  deviceSize.width * 0.1,
                  deviceSize.height * 0.1),
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
                  onPressed: () async {
                    print(nameInputController.text);
                    print(imageUrl);
                    print(userContent.reference);
                    _db.collection('users').document(user.uid).updateData(
                      <String, dynamic>{
                      "name": nameInputController.text,
                      "photoUrl": imageUrl,
                    }).then((_){Navigator.of(context).pop();});
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
