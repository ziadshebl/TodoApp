const functions = require('firebase-functions');
var schedule = require('node-schedule');
const admin = require('firebase-admin');
const firebase = require('firebase');


admin.initializeApp();
firebase.initializeApp(
    {
        databaseURL: 'https://todo-9a42e.firebaseio.com',
        credential: admin.credential.applicationDefault(),
        projectId: 'todo-9a42e',
        apiKey: "AIzaSyDpu4GioG8iw2g5XHJmZ0FO_-pDIbtxqEc",
        authDomain: "todo-9a42e.firebaseapp.com",
        storageBucket: "todo-9a42e.appspot.com",
        messagingSenderId: "445694427532",
        appId: "1:445694427532:android:c2ddce8b08bfd6f31396a9",
    }
);

exports.myFunction = functions.firestore
    .document('users/{user}/tasks/{task}')
    .onCreate((snapshot, context) => {
        var date = snapshot.data()['dueTo'].toDate()
        console.log(date)
        console.log(snapshot.ref.parent.parent.id)
        date.setHours(date.getHours() - 1);
        console.log(date)
        return schedule.scheduleJob(date, function () {
            admin.messaging().sendToTopic(snapshot.ref.parent.parent.id, { notification: { title: 'Time is running out', body: `${snapshot.data()['taskTitle']} deadine is within one hour, hurry up!!`} })
        })
    });
