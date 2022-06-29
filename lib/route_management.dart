import 'package:flutter/material.dart';
import 'package:to_do_list/screens/add_to_do/add_to_do_screen.dart';
import 'package:to_do_list/screens/error_screen/error_screen.dart';
import 'package:to_do_list/screens/home/home_screen.dart';

class RouteManagement {
  static const String root = '/';
  static const String addToDo = '/add-to-do';
  static const String error = '/error';

  RouteManagement._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var routeName = settings.name;

    switch (routeName) {
      case root:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case addToDo:
        return MaterialPageRoute(builder: (_) => const AddToDoScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => const ErrorScreen(
                errorMessage: 'Oops! looks like you took a wrong turn.'));
    }
  }
}
