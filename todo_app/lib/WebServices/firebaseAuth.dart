import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Screens/Home_screen.dart';
import 'package:flutter/material.dart';
import '../utils.dart' as utils;

class FirebaseAuthentication{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final Firestore _db = Firestore.instance;
    String _verificationId;

  void signupWithEmail(
      String email, String password, String name, BuildContext context) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        _db.collection("users").document(user.user.uid).setData({
          "email": email,
          "name": name,
          "lastLogedIn": DateTime.now(),
          "signinMethod": user.user.providerId
        });

      Navigator.of(context).popUntil(ModalRoute.withName('/intro_screen'));
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }).catchError((e) {
        utils.showErrorDialog('Error', '${e.message}', context);
      });
    } else {
      utils.showErrorDialog(
          'Error', 'Please provide email and password', context);
    }
  }

    void signInWithEmail(String email, String password, BuildContext context) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        _db.collection("users").document(user.user.uid).updateData({
          "email": email,
          "lastLogedIn": DateTime.now(),
          "signinMethod": user.user.providerId
        });
      Navigator.of(context).popUntil(ModalRoute.withName('/intro_screen'));
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }).catchError((e) {
        utils.showErrorDialog('Error', '${e.message}', context);
      });
    } else {
      utils.showErrorDialog(
          'Error', 'Please provide email and password', context);
    }
  }

  



    
  void signinUsingGoogle(context) async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;

      if (user != null) {
        _db.collection("users").document(user.uid).setData({
          "email": user.email,
          "name": user.displayName,
          "photoUrl": user.photoUrl,
          "lastLogedIn": DateTime.now(),
          "signinMethod": user.providerId
        });
      Navigator.of(context).popUntil(ModalRoute.withName('/intro_screen'));
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    } catch (e) {
      utils.showErrorDialog('Error', '${e.message}', context);
    }
  }



  
  Future<void> verifyPhone(phoneNo, context) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      return null;
    };

    final PhoneVerificationFailed failed = (AuthException authException) {
      utils.showErrorDialog('Error', '${authException.message}', context);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      return _verificationId = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      return _verificationId = verId;
    };
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: failed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  void signInWithPhoneNumber(String smsText, BuildContext context) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsText);

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();

    assert(user.uid == currentUser.uid);

    if (user != null) {
      _db.collection("users").document(user.uid).setData({
        "phoneNumber": user.phoneNumber,
        "name": 'Unkown',
        "lastLogedIn": DateTime.now(),
        "signinMethod": user.providerId,
        
      });
      Navigator.of(context).popUntil(ModalRoute.withName('/intro_screen'));
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      print('FAILED');
    }
  }

  

}