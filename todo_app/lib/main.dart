//Packages
import 'package:flutter/material.dart';
import 'package:todo_app/Screens/Home_screen.dart';
import 'package:todo_app/Screens/Login_screen.dart';
import 'package:todo_app/Screens/Phone_Screen.dart';
import 'package:todo_app/Screens/Signup_screen.dart';
import './Screens/EditProfile_screen.dart';
import './Screens/Splash_Screen.dart';
import 'Screens/Intro_screen.dart';
import './Screens/Task_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    



    
    return MaterialApp(
        //Disabling the debug banner
        debugShowCheckedModeBanner: false,
        title: 'TODO',
        theme: ThemeData(primaryColor: Color.fromRGBO(127, 216, 88, 1)),
        //Setting the default screen
        home: SplashScreen(),
        //Defining the routes of the different screens
        routes: {
          IntroScreen.routeName: (ctx) => IntroScreen(),
          LoginScreen.routeName: (ctx)=>LoginScreen(),
          SignupScreen.routeName: (ctx)=>SignupScreen(),
          PhoneScreen.routeName: (ctx)=>PhoneScreen(),
          HomeScreen.routeName: (ctx)=>HomeScreen(),
          SplashScreen.routeName: (ctx)=>SplashScreen(),
          EditProfileScreen.routeName: (ctx)=>EditProfileScreen(),
          TaskScreen.routeName: (ctx)=>TaskScreen(),

        }
    );
  }
}
