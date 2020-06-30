import 'package:flutter/material.dart';
import '../WebServices/firebaseAuth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible;
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final FirebaseAuthentication firebaseAuth = FirebaseAuthentication();

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(
                  10, deviceSize.height * 0.1, 10, deviceSize.height * 0.1),
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/TodoLogo.png',
                  width: deviceSize.width * 0.6,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  deviceSize.width * 0.1, 5, deviceSize.width * 0.1, 5),
              child: TextFormField(
                focusNode: emailFocusNode,
                controller: emailInputController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black54,
                  ),
                  labelText: 'E-mail',
                  filled: true,
                  fillColor: Colors.grey[200].withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                style: TextStyle(),
                cursorColor: Color.fromRGBO(127, 216, 88, 1),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  deviceSize.width * 0.1, 5, deviceSize.width * 0.1, 5),
              child: TextFormField(
                controller: passwordInputController,
                focusNode: passwordFocusNode,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black54,
                  ),
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[200].withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(),
                cursorColor: Color.fromRGBO(127, 216, 88, 1),
              ),
            ),
            Container(
              width: deviceSize.width * 0.8,
              height: deviceSize.height * 0.065,
              margin: EdgeInsets.fromLTRB(
                  deviceSize.width * 0.1,
                  deviceSize.height * 0.01,
                  deviceSize.width * 0.1,
                  deviceSize.height * 0.05),
              child: FloatingActionButton(
                onPressed: () {
                    firebaseAuth.signInWithEmail(
                      emailInputController.text, passwordInputController.text, context);
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
          ],
        ),
      ),
    );
  }
}
