import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:janakalyan_admin/screen/drawer/drawer.dart';
import 'package:janakalyan_admin/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          MaterialButton(
            onPressed: () async{
              SharedPreferences sp = await SharedPreferences.getInstance();
              sp.setBool("isLogged", false);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            },
            child: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
