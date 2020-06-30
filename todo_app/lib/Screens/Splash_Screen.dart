///Importing dart/flutter libraries to user them.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_app/Screens/Home_screen.dart';
import './Intro_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

///A screen appearing when the user launches the app.
///It shows spotify logo for a while.
///It decides which screen will be pushed next.
class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  ///Animation attributes.
  AnimationController _animationController;
  Animation<double> animation;

  ///Indicates if the data is read from the memory yet.
  bool dataUpdated = false;

  ///Indicates if the user is authorized.
  bool isAuth = false;

  ///Indicates if the API url is read from the config file.
  bool urlInitialized = false;

  ///Initializations.
  ///Reading the API url from config file in the assets.
  ///Starting the animation of the logo.
  ///Start the timer.
  void initState() {
    urlInitialized = false;
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    animation = Tween<double>(begin: 150, end: 170).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    ));
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.repeat();
      }
    });
    _animationController.forward();
    dataUpdated = false;
    startTimer();
  }

  ///Starts a 6 seconds timer.
  ///After the time is up, either intro screen/home screen is loaded.
  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect after 3 seconds
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  ///Choosing the appropriate screen to show based on cached data.
  void navigateUser() async {
    if (isAuth) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(IntroScreen.routeName);
    }
  }

  void checkCurrentUser()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user==null){
      isAuth=false;
    }
    else{
      isAuth=true;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkCurrentUser();
    ///Showing the animated logo at the center of the screen.
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Center(
                child: Container(
              height: animation.value,
              child:Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/TodoLogo.png',
              ),
            ),
            ));
          }),
    );
  }
}
