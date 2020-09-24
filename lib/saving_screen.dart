import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:SPENNapp/api/api.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:SPENNapp/home_screen.dart';
import 'package:SPENNapp/profile_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Saving extends StatefulWidget {
  @override
  _SavingState createState() => _SavingState();
}

class _SavingState extends State<Saving> {
  var userData;
  List data = [];
  int _index = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  TextEditingController _phoneTextEditController = new TextEditingController();
  String phoneCode = "250";
  bool isLoading = false;
  final sendToController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    _getUserInfo();
    this.getDatas();

    super.initState();
  }

  Future<String> getDatas() async {
    final token = await getToken();
    var response = await http.get(
        Uri.encodeFull("https://spenn.herokuapp.com/savingapi/"),
        headers: {HttpHeaders.authorizationHeader: "JWT $token"});
    print(response.body);
    print(token);
    this.setState(() {
      data = jsonDecode(response.body);
    });
    print("Success");

    return "Success!";
  }

  void _getUserInfo() async {
    SharedPreferences kubika = await SharedPreferences.getInstance();
    var userJson = kubika.getString('user');
    var user = json.decode(userJson);

    setState(() {
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saving',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login_bottom.png"),
              fit: BoxFit.scaleDown,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      children: [
                        // Container(
                        //   padding: EdgeInsets.all(8.0),
                        //   child: _sendToField('Send money to'),
                        // ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: _amountField('Amount'),
                        ),
                        Container(
                          child: RaisedButton(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            color: Colors.tealAccent,
                            onPressed: () {
                              if (!isLoading) {
                                setState(() {
                                  isLoading = true;
                                });
                                _sendMoney();
                              }
                            },
                            child: !isLoading
                                ? Text(
                                    'Deposit',
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
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent transaction',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View all',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Expanded(
                    child: Container(
                  child: ListView(
                    children: data
                            .map((prof) => _transactionCard(
                                  'Deposited on',
                                  prof['amount'].toString(),
                                  prof['paymenton'].toString(),
                                ))
                            .toList() ??
                        [],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _sendToField(String title) => TextField(
        // duhamagare controller

        obscureText: false,
        style: TextStyle(color: Colors.teal),
        controller: sendToController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: title,
          icon: Icon(FontAwesome.user_circle_o),
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
        ),
      );
  TextField _amountField(String title) => TextField(
        // duhamagare controller

        obscureText: false,
        style: TextStyle(color: Colors.teal),
        controller: amountController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: title,
          icon: Icon(FontAwesome.dollar),
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
        ),
      );

  // text field for sending money
  void _sendMoney() async {
    setState(() {
      isLoading = true;
    });
    var username = await getUser();
    var data = {
      'amount': amountController.text,
      'sender': username,
    };
//
    var res = await CallApi().sendMoney(data, 'savingapi/');
    var body = json.decode(res.body);

    print(body['status']);
    setState(() {
      isLoading = false;
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Saving "),
            content: Text("Saving Completed!"),
          );
        });
  }
}

Widget _buildSendCard(String title) {
  return Center(
    child: SizedBox(
      height: 120, // card height
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        child: Center(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
              child: Center(
                child: Icon(
                  AntDesign.swap,
                  color: Colors.teal,
                  size: 20.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      color: Colors.grey),
                ),
              ),
            ),
          ],
        )),
      ),
    ),
  );
}

Widget _buildTopupCard(String title) {
  return Center(
    child: SizedBox(
      height: 120, // card height
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        child: Center(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
              child: Center(
                child: Icon(
                  FontAwesome.credit_card,
                  color: Colors.teal,
                  size: 20.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      color: Colors.grey),
                ),
              ),
            ),
          ],
        )),
      ),
    ),
  );
}

Widget _transactionCard(String motif, String amount, String time) {
  return Expanded(
    child: Container(
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.amber[600],
                  child: ClipOval(
                    child: Image.asset('assets/user.png'),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(vertical: 11.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      motif,
                      style: TextStyle(color: Colors.grey, fontSize: 11.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      time,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
              Expanded(
                  child: Container(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                child: Text('RWF${amount}',
                    style:
                        TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold)),
              ))
            ],
          ),
        ),
      ),
    ),
  );
}

_setHeaders() => {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

getToken() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var token = localStorage.getString('token');

  return '$token';
}

getUser() async {
  SharedPreferences kubika = await SharedPreferences.getInstance();

  var user = kubika.getString('user');
  var username = json.decode(user);
  var usen = username['username'];

  return '$usen';
}
