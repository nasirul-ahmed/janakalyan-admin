import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/deposit_history_model.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DepositHistory extends StatefulWidget {
  const DepositHistory({Key? key}) : super(key: key);

  @override
  _DepositHistoryState createState() => _DepositHistoryState();
}

class _DepositHistoryState extends State<DepositHistory> {
  Future<List<DepositHistoryModel>> getCustomerDepositHistory() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    //final url = Uri.parse('$janaklyan/api/admin/success-deposits');
    final url = Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed
            .map<DepositHistoryModel>(
                (json) => DepositHistoryModel.fromJson(json))
            .toList();
      }
      return List<DepositHistoryModel>.empty();
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: Colors.white, fontSize: 18);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deposit Collection Details"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: Container(
                      color: Colors.red,
                      height: 110,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "All time Collection Amount (Rs) :  ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Maturity Settlement Amount (Rs) : ",
                              style: style,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Total Remaining Amount (Rs) :  ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width * 0.6,
            height: 50,
            color: Colors.blueAccent,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Some of deposits",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: FutureBuilder<List<DepositHistoryModel>>(
                  future: getCustomerDepositHistory(),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return const Text("Somethings not right");
                    } else if (snap.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snap.data!.length,
                          itemBuilder: (context, id) {
                            return CustomListTile(snap.data![id]);
                          });
                    } else {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  DepositHistoryModel depositHistoryModel;
  CustomListTile(this.depositHistoryModel);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text("Amount: ${depositHistoryModel.amount}"),
        subtitle: Text("Collector ID: ${depositHistoryModel.collectorId}"),
        trailing: Text("Date : ${formatDate(depositHistoryModel.createdAt)}"),
      ),
    );
  }
}
