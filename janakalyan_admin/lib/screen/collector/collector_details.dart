import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/collector_model.dart';
import 'package:janakalyan_admin/screen/collector/collection_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CollectorDetails extends StatelessWidget {
  const CollectorDetails({Key? key}) : super(key: key);

  Future<List<Collector>> getCollector() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/collectors-list');
    //final url = Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed
            .map<Collector>((json) => Collector.fromJson(json))
            .toList();
      }
      return List<Collector>.empty();
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collectors"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: FutureBuilder<List<Collector>>(
            future: getCollector(),
            builder: (context, snap) {
              if (snap.hasError) {
                return Center(
                  child: Text("No Collectors"),
                );
              } else if (snap.hasData) {
                return ListView.builder(
                    itemCount: snap.data!.length,
                    itemBuilder: (_, id) {
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CollectionDetails(
                                  collector: snap.data![id],
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text("${snap.data![id].name}"),
                          subtitle:
                              Text("Collector Code: ${snap.data![id].id}"),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "Deposit Collection Rs. ${snap.data![id].totalCollection}"),
                              Text(
                                  "Loan Collection Rs. ${snap.data![id].totalLoanCollection}"),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
