import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/Screens/Phone_Screen.dart';
import 'package:todo_app/Screens/Signup_screen.dart';
import 'Login_screen.dart';
import '../WebServices/firebaseAuth.dart';


class IntroScreen extends StatefulWidget {
  static const routeName = '/intro_screen';
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  

  final FirebaseAuthentication firebaseAuth = FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, deviceSize.height * 0.2, 10, 5),
            child: Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/TodoLogo.png',
                width: deviceSize.width * 0.4,
              ),
            ),
          ),
          Container(
            width: deviceSize.width * 0.8,
            height: deviceSize.height * 0.065,
            margin: EdgeInsets.fromLTRB(
                deviceSize.width * 0.1,
                deviceSize.height * 0.07,
                deviceSize.width * 0.1,
                deviceSize.height * 0.01),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SignupScreen.routeName);
              },
              backgroundColor: Colors.white,
              heroTag: "btn1",
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: Color.fromRGBO(127, 216, 88, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: deviceSize.width * 0.05,
                ),
              ),
            ),
          ),
          Container(
            width: deviceSize.width * 0.8,
            height: deviceSize.height * 0.065,
            margin: EdgeInsets.fromLTRB(
                deviceSize.width * 0.1,
                deviceSize.height * 0.02,
                deviceSize.width * 0.1,
                deviceSize.height * 0.08),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
              backgroundColor: Colors.white,
              heroTag: "btn2",
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Color.fromRGBO(127, 216, 88, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: deviceSize.width * 0.05,
                ),
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Expanded(
                child: Divider(
              thickness: 1.2,
              color: Colors.black54,
            )),
            Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Text(
                  "OR",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                )),
            Expanded(
                child: Divider(
              thickness: 1.2,
              color: Colors.black54,
            )),
          ]),
          SizedBox(height: deviceSize.height * 0.02),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: FlatButton.icon(
                  onPressed: () {
                    firebaseAuth.signinUsingGoogle(context);
                  },
                  icon: Icon(
                    FontAwesomeIcons.google,
                    color: Colors.black54,
                  ),
                  label: Text('Continue With Google',
                      style: TextStyle(
                          fontSize: deviceSize.width * 0.04,
                          color: Colors.black54)),
                ),
              ),
              Container(
                child: FlatButton.icon(
                  onPressed: () {
                     Navigator.of(context).pushNamed(PhoneScreen.routeName);
                  },
                  icon: Icon(
                    Icons.phone,
                    color: Colors.black54,
                  ),
                  label: Text(
                    'Continue With Phone',
                    style: TextStyle(
                        fontSize: deviceSize.width * 0.04,
                        color: Colors.black54),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }  
}
