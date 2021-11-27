import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "Drawer",
      child: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const InkWell(
            child: SizedBox(
              height: 200,
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                accountEmail: Text('Admin'),
                accountName:
                    Text('janakalyan-ag', style: TextStyle(fontSize: 20)),
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.black,
                  //shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Matured Accounts',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (_) => PassBook()));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Closed Loans',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (_) => PassBook()));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Add Collector',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (_) => PassBook()));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
