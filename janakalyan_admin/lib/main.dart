import 'package:flutter/material.dart';
import 'package:janakalyan_admin/screen/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Index();
  }
}

// class Wrapper extends StatefulWidget {
//   const Wrapper({ Key? key }) : super(key: key);

//   @override
//   State<Wrapper> createState() => _WrapperState();
// }

// class _WrapperState extends State<Wrapper> {
//   SharedPreferences? _preferences;
//   @override
//   void initState() {
//     super.initState();
//     getPrefs();
//   } 

//   getPrefs() async{
//      SharedPreferences _preferences = await SharedPreferences.getInstance(); 
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  _preferences!.getBool("isLogged") == false ? Login(): DashBoard();
//   }
// }