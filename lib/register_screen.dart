import 'package:SPENNapp/home_screen.dart';
import 'package:SPENNapp/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:SPENNapp/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  TextEditingController _phoneTextEditController = new TextEditingController();
  String phoneCode = "250";
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullnameController = TextEditingController();

  showMessage(msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: false,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          'assets/logo.png',
                          width: MediaQuery.of(context).size.width * 0.50,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        child: Form(
                          key: _formState,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Get started,",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Get account for free",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 1.0,
                                  right: 1.0,
                                  top: 20.0,
                                ),
                              ),
                              Card(
                                elevation: 0.0,
                                margin: EdgeInsets.only(top: 10.0),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.black.withOpacity(0.15),
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: CountryCodePicker(
                                            onChanged: print,
                                            initialSelection: 'RW',
                                            // optional. Shows only country name and flag
                                            showFlagDialog: true,
                                            // optional. Shows only country name and flag when popup is closed.
                                            showOnlyCountryWhenClosed: false,
                                            // optional. aligns the flag and the Text left
                                            alignLeft: false,
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: TextFormField(
                                            controller:
                                                _phoneTextEditController,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textInputAction:
                                                TextInputAction.done,
                                            validator: (v) => v.isEmpty
                                                ? 'Phone number is required'
                                                : null,
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          style: BorderStyle
                                                              .none)),
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.none)),
                                              disabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          style: BorderStyle
                                                              .none)),
                                              errorBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.none)),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          style: BorderStyle
                                                              .none)),
                                              focusedErrorBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          style: BorderStyle
                                                              .none)),
                                            ),
                                            inputFormatters: [
                                              new BlacklistingTextInputFormatter(
                                                new RegExp('[\\.|\\,|\\-|\\ ]'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              // Add Input for fullname
                              textFullname(
                                  'Fullname', Icons.supervised_user_circle),
                              SizedBox(
                                height: 10.0,
                              ),
                              textPassword("Password/Pincode", Icons.lock),
                              //end input
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 25.0),
                                child: ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: RaisedButton(
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    color: Colors.tealAccent,
                                    onPressed: () {
                                      if (!isLoading) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                      }
                                      _Registration();
                                    },
                                    child: !isLoading
                                        ? Text(
                                            'Signup',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          )
                                        : SpinKitThreeBounce(
                                            color: Colors.white,
                                            size: 15.0,
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Center(
                                child: Text(
                                  " Do you have an Account?",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.0),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 25.0),
                                child: ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: OutlineButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    color: Colors.deepOrangeAccent,
                                    onPressed: () {
                                      // if (!isLoading) {
                                      //   setState(() {
                                      //     isLoading = true;
                                      //   });
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => Login()),
                                      );
                                      // }
                                    },
                                    child: !isLoading
                                        ? Text(
                                            'Login',
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : SpinKitThreeBounce(
                                            color: Colors.white,
                                            size: 15.0,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextField textPassword(String title, IconData icon) => TextField(
        // duhamagare controller

        obscureText: true,
        style: TextStyle(color: Colors.teal),
        controller: passwordController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: "Enter password",
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
        ),
      );

  TextField textFullname(String title, IconData icon) => TextField(
        obscureText: false,
        style: TextStyle(color: Colors.teal),
        controller: fullnameController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: "Enter Fullname",
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
        ),
      );

  void _Registration() async {
    setState(() {
      isLoading = true;
    });
    var code = phoneCode;
    var tel = _phoneTextEditController.text;
    var _tel = "$code${int.parse(tel)}";
    var data = {
      'first_name': fullnameController.text,
      'last_name': fullnameController.text,
      'username': _tel,
      'password': passwordController.text,
    };
//
    var res = await CallApi().postData(data, 'users/create');
    var body = json.decode(res.body);
    print(_tel);
    print(body);
    var bodresult = body['created'];
    print(bodresult);

    if (bodresult == 'successful') {
      // showMessage("Account have been created!");
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          backgroundColor: Colors.greenAccent.shade200,
          duration: Duration(seconds: 3),
          content: Text('Account Have sucessful created!'),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          duration: Duration(seconds: 3),
          content: Text('Account creation failed or username exists!'),
        ),
      );
      // showMessage("account failed to be created/user already exist!");
    }
  }

  Widget FadeAlertAnimation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
