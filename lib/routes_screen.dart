import 'package:SPENNapp/onboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:SPENNapp/main.dart';
import 'package:SPENNapp/home_screen.dart';
import 'package:SPENNapp/register_screen.dart';

class Routegenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => OnBoardScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => Register());
      case '/moredetails':
        return MaterialPageRoute(builder: (_) => HomeScreen());

        // if (args is String) {
        //   return MaterialPageRoute(builder: (_) => HomeScreen(data: args));
        // } else {
        //   return MaterialPageRoute(builder: (_) => HomeScreen(data: args));
        // }

        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Text('No available routes');
    });
  }
}
