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

class BillsPayment extends StatefulWidget {
  @override
  _BillsPaymentState createState() => _BillsPaymentState();
}

class _BillsPaymentState extends State<BillsPayment> {
  var userData;
  List data;
  int _index = 0;
//https://jsonplaceholder.typicode.com/posts
  Future<String> getData() async {
    final token = await getToken();
    var response = await http.get(
        Uri.encodeFull("https://kibinapay.com/moneysendapi/"),
        headers: {HttpHeaders.authorizationHeader: "JWT $token"});
//    print("my token is:$token ");
    this.setState(() {
      data = jsonDecode(response.body);
    });
    print("Success");

    return "Success!";
  }

  bool isLoading = false;
  final sendToController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    _getUserInfo();
    this.getData();

    super.initState();
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
          'Bills Payment',
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
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.0,
                  shrinkWrap: true,
                  mainAxisSpacing: 10.0,
                  children: [
                    _electricityCard(context, 'Electricity'),
                    _waterCard(context, 'Water'),
                    _waterCard(context, 'QR Payment'),
                  ],
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
                    children: [
                      _trasactionCard(
                          'payment of salary', 'RWF5000.0 ', 'Today 22 Sept'),
                      _trasactionCard(
                          'payment of salary', 'RWF5000.0', 'Today 22 Sept'),
                      _trasactionCard(
                          'payment of salary', 'RWF5000.0', 'Today 22 Sept'),
                    ],
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
          icon: Icon(FontAwesome.phone_square),
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
}

Widget _trasactionCard(String motif, String amount, String time) {
  return Container(
    child: SizedBox(
      height: 80,
      width: double.infinity,
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    time,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(amount,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ))
          ],
        ),
      ),
    ),
  );
}

Widget _electricityCard(BuildContext context, String title) {
  return Center(
    child: SizedBox(
      height: 120, // card height
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (_) => SendMoney()),
          // );
        },
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
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
    ),
  );
}

Widget _waterCard(BuildContext context, String title) {
  return Center(
    child: SizedBox(
      height: 120, // card height
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (_) => BillsPayment()),
          // );
        },
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
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
    ),
  );
}

_setHeaders() => {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

getToken() async {
  SharedPreferences kubika = await SharedPreferences.getInstance();
  var token = kubika.getString('token');

  return '$token';
}
