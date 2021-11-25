import 'dart:async';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/screen/homescreen/dashboard.dart';
import 'package:janakalyan_admin/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Index extends StatelessWidget {
  const Index({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Splash(),
      
      routes: {
        // '/dashboard': (context) => const DashBoard(),
        // '/login': (context) => const Login(),
        Splash.id : (context) => const Splash(),
      },
      initialRoute: Splash.id,
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  static const id = "Splash";

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void setTimer() {
    Timer(const Duration(seconds: 3), () => {navigateUser()});
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogged = prefs.getBool('isLogged') ?? false;
    if (isLogged) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (c) => const DashBoard()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const Login()), (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    setTimer();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
