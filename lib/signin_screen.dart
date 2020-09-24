import 'package:SPENNapp/home_screen.dart';
import 'package:SPENNapp/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:SPENNapp/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  TextEditingController _phoneTextEditController = new TextEditingController();
  String phoneCode = "250";
  bool isLoading = false;
  final passwordController = TextEditingController();
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
                                child: Text(
                                  "Phone Number",
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.bodyText1,
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
                                      SingleChildScrollView(
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
                              textPassword("Password/Pincode", Icons.lock),
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
                                        _login();
                                      }
                                    },
                                    child: !isLoading
                                        ? Text(
                                            'Login',
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
                                height: 10.0,
                              ),
                              Center(
                                child: Text(
                                  " Don't you have an Account",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.0),
                                ),
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
                                              builder: (_) => Register()),
                                        );
                                        // }
                                      },
                                      child: Text(
                                        'Signup',
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      )),
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

  void _login() async {
    setState(() {
      isLoading = true;
    });
    var code = phoneCode;
    var tel = _phoneTextEditController.text;
    var _tel = "$code${int.parse(tel)}";
    var data = {
      'username': _tel,
      'password': passwordController.text,
    };
//
    var res = await CallApi().postData(data, 'token-auth/');
    var body = json.decode(res.body);

    print(body['token']);

    if (body['success'] == 'Successful') {
      //kubika data dufite
      SharedPreferences kubika = await SharedPreferences.getInstance();
      kubika.setString('token', body['token']);
      kubika.setString('user', json.encode(body['user']));

      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => HomeScreen()));

      print("You have successfull logged in");
    } else {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          duration: Duration(seconds: 3),
          content: Text('Invalid password or username !'),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }
}
