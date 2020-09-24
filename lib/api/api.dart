import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'https://spenn.herokuapp.com/';

  postData(data, apiUrl) async {
    var fullurl = _url + apiUrl + await getToken();
    return await http.post(fullurl,
        body: json.encode(data), headers: _setHeaders());
  }

  sendMoney(data, apiUrl) async {
    var fullurl = _url + apiUrl;
    var token = await getTokens();
    return await http.post(fullurl, body: json.encode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "JWT $token"
    });
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl + await getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    return '?token=$token';
  }

  getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var abauser = localStorage.getString('user');

    return abauser;
  }

  getTokens() async {
    SharedPreferences kubika = await SharedPreferences.getInstance();
    var token = kubika.getString('token');

    return '$token';
  }
}
