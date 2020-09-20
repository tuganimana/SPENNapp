import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    top: MediaQuery.of(context).size.height * 0.20,
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
                              Text(
                                "Get started,",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                "Create an Account",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black.withOpacity(0.4),
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
                                              new FilteringTextInputFormatter(
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
                                        // _sendVerificationCode(context);
                                        // Navigator.pushAndRemoveUntil(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => HomePage(),
                                        //   ),
                                        //   ModalRoute.withName("/homepage"),
                                        // );
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
}
