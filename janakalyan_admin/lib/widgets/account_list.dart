import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/customer.dart';
import 'package:janakalyan_admin/utils/parse_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountList extends StatefulWidget {
  // final Customer customer;

  //const AccountList(Key key):super(key: key);

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  final email = TextEditingController();


Future<List<Customer>> getCustomer() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/get-customer');

    try {
      var res = await http.get(url,
          
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          });
      if (200 == res.statusCode) {
        print(jsonDecode(res.body).toString());
        return compute(parseCustomer, res.body);
      }
      return List<Customer>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // @override
  // void initState() {
  //   _searchAc.addListener(() {
  //     //here you have the changes of your textfield
  //     print("value: ${_searchAc.text}");
  //     //use setState to rebuild the widget
  //     setState(() {
  //       query = _searchAc.text;
  //     });
  //   });
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      color: Colors.grey,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: TextFormField(
                cursorWidth: 2.0,
                style: const TextStyle(color: Colors.black),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Required*';
                  }
                  return null;
                },
                controller: email,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.white),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  labelText: 'Search an Account',
                  labelStyle:
                      const TextStyle(color: Colors.black, letterSpacing: 3),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.white, width: 2, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder<List<Customer>>(
            future: getCustomer(),
            builder: (context, snap) {
              if (snap.hasError) {
                return const CircularProgressIndicator.adaptive();
              } else if (snap.hasData) {
                return ListView.builder(
                    itemCount: snap.data?.length,
                    itemBuilder: (context, id) {
                      return customListTile(snap.data![id]);
                    });
              } else {
                return const Text("Something Wrong");
              }
            },
          )
        ],
      ),
    );
  }
}

class customListTile extends StatelessWidget {
  Customer customer;
  customListTile(this.customer);

  @override
  Widget build(BuildContext context) {
    Uint8List? profile = Base64Decoder().convert(customer.profile ?? '');
    return ListTile(
      leading: customer.profile == null
          ? const CircleAvatar(
              child: Icon(Icons.person),
            )
          : Container(
              width: 40,
              height: 40,
              //child: Image.memory(profile),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: MemoryImage(profile),
                  fit: BoxFit.fill,
                ),
              ),
            ),
    );
  }
}
