import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../WebServices/firebaseAuth.dart';

class PhoneScreen extends StatefulWidget {
  static const routeName = '/phone_screen';
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final phoneFocusNode = FocusNode();
  final verificationCodeInputController = TextEditingController();
    final FirebaseAuthentication firebaseAuth = FirebaseAuthentication();
  

  PhoneNumber _phoneNumber;
  bool _isSMSsent = false;

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
        child: AnimatedContainer(
          duration: Duration(milliseconds: 5000),
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
                width: deviceSize.width * 0.8,
                child: InternationalPhoneNumberInput(
                  onInputChanged: (phoneNumberTxt) {
                    _phoneNumber = phoneNumberTxt;
                  },
                  countries: ['EG'],
                ),
              ),
              _isSMSsent
                  ? Container(
                      margin: EdgeInsets.fromLTRB(
                          deviceSize.width * 0.1, deviceSize.height*0.03, deviceSize.width * 0.1, 5),
                      child: TextFormField(
                        controller: verificationCodeInputController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black54,
                          ),
                          labelText: 'Verification Code',
                          filled: true,
                          fillColor: Colors.grey[200].withOpacity(0.7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.black54, fontSize: 15),
                        ),
                        style: TextStyle(),
                        cursorColor: Color.fromRGBO(127, 216, 88, 1),
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 6,
                      ),
                    )
                  : SizedBox(),
              _isSMSsent
                  ? Container(
                      width: deviceSize.width * 0.8,
                      height: deviceSize.height * 0.065,
                      margin: EdgeInsets.fromLTRB(
                          deviceSize.width * 0.1,
                          deviceSize.height * 0.03,
                          deviceSize.width * 0.1,
                          deviceSize.height * 0.01),
                      child: FloatingActionButton(
                        onPressed: () {
                          firebaseAuth.signInWithPhoneNumber(verificationCodeInputController.text,context);
                        },
                        backgroundColor: Colors.white,
                        heroTag: "btn2",
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Text(
                          'Verify',
                          style: TextStyle(
                            color: Color.fromRGBO(127, 216, 88, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: deviceSize.width * 0.05,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: deviceSize.width * 0.8,
                      height: deviceSize.height * 0.065,
                      margin: EdgeInsets.fromLTRB(
                          deviceSize.width * 0.1,
                          deviceSize.height * 0.1,
                          deviceSize.width * 0.1,
                          deviceSize.height * 0.05),
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            firebaseAuth.verifyPhone(_phoneNumber.phoneNumber, context);
                            _isSMSsent = true;
                          });
                        },
                        backgroundColor: Colors.white,
                        heroTag: "btn2",
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Text(
                          'Send SMS',
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
      ),
    );
  }
  
  }
