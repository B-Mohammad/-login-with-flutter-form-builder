import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanker_login/dashboard.dart';
import 'package:tanker_login/login.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _goRouter = GoRouter(
  redirect: (context, state) => tokenExist(context), //redirect
  routes: [
    GoRoute(
      path: "/", //login route
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: "/dashboard", //dashboard route
      builder: (context, state) => const Dashboard(),
    )
  ],
);

Future<String> tokenExist(BuildContext context) async {
  //redirect method: check for token exist
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? "";
  print("Token: ${token}");
  if (token.isNotEmpty) {
    return "/dashboard";
  }
  return "/";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'tank task',
        debugShowCheckedModeBanner: false,
        routerConfig: _goRouter);
  }
}
