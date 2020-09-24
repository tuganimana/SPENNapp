import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:SPENNapp/api/api.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:SPENNapp/profile_screen.dart';
import 'package:SPENNapp/sendmoney.dart';
import 'package:SPENNapp/top_up.dart';
import 'api/allQuery.dart';
import 'package:SPENNapp/bills_screen.dart';
import 'package:SPENNapp/saving_screen.dart';
import 'package:SPENNapp/wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var kibinascreens = [
    HomeScreen1(),
    BillsPayment(),
    Saving(),
    Wallet(),
    ProfileScreen(),
  ];
  Map welcome;
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.tealAccent,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.teal,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.yellow))),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(FontAwesome.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(FontAwesome.money), title: Text('Bills')),
            BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on), title: Text('Saving')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                title: Text('Wallet')),
            BottomNavigationBarItem(
                icon: Icon(FontAwesome.user_circle), title: Text('Profile'))
          ],
          onTap: (ahabanza) {
            setState(() {
              selectedTab = ahabanza;
            });
          },
          showUnselectedLabels: true,
          iconSize: 20.0,
        ),
      ),

      body: kibinascreens[selectedTab],
    );
  }

  void getTransaction() async {
    var res = await CallApi().getData('moneysendapi/');
  }
}

class HomeScreen1 extends StatefulWidget {
  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  var userData;
  List data = [];
  int _index = 0;

//https://jsonplaceholder.typicode.com/posts
  Future<String> getData() async {
    final token = await getToken();
    var response = await http.get(
        Uri.encodeFull("https://spenn.herokuapp.com/moneysendapi/"),
        headers: {HttpHeaders.authorizationHeader: "JWT $token"});
//    print("my token is:$token ");
    this.setState(() {
      data = jsonDecode(response.body);
    });
    print(data);

    return "Success!";
  }

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
    var fullname = user['first_name'];

    setState(() {
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              Stack(
                children: <Widget>[
                  //dushyire data zibanza
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ahari information zibanza
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Welcome ',
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor: Colors.amber[600],
                                    child: ClipOval(
                                      child: Image.asset('assets/user.png'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          userData != null ? "${userData['first_name']} " : "",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 2.0,
                shrinkWrap: true,
                mainAxisSpacing: 10.0,
                children: [
                  _buildSendCard(context, 'Send/Receive'),
                  _buildTopupCard(context, 'Top Up'),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All transaction',
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
              Expanded(
                  child: Container(
                child: ListView(
                  children: data
                          .map((prof) => _trasactionCard(
                                prof['description'].toString(),
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
    );
  }
}

Widget _buildSendCard(BuildContext context, String title) {
  return Center(
    child: SizedBox(
      height: 120, // card height
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => SendMoney()),
          );
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

Widget _buildTopupCard(BuildContext context, String title) {
  return Center(
    child: SizedBox(
      height: 120, // card height
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => TopUp()),
          );
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

Widget _trasactionCard(String motif, String amount, String time) {
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

//Navigate sendmney  screen

_setHeaders() => {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

getToken() async {
  SharedPreferences kubika = await SharedPreferences.getInstance();
  var token = kubika.getString('token');
  var user = kubika.getString('user');
  var username = json.decode(user);
  print(username['username']);

  return '$token';
}

getUser() async {
  SharedPreferences kubika = await SharedPreferences.getInstance();
  var token = kubika.getString('token');
  var user = kubika.getString('user');
  var username = json.decode(user);
  var name = username['first_name'];

  return '$name';
}
