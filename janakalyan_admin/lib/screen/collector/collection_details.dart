import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/collector_model.dart';
import 'package:janakalyan_admin/screen/deposit_history/collector_deposits.dart';
import 'package:janakalyan_admin/screen/transactions/deposits_till_day.dart';
import 'package:janakalyan_admin/services/today_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CollectionDetails extends StatefulWidget {
  final Collector? collector;
  const CollectionDetails({Key? key, this.collector}) : super(key: key);

  @override
  State<CollectionDetails> createState() => _CollectionDetailsState();
}

class _CollectionDetailsState extends State<CollectionDetails> {
  @override
  void initState() {
    super.initState();
  }

  Future<num?> todayCollection() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/today-collection/collector');
    var selectedDate = DateTime.now();
    var jsonBody = jsonEncode(<String, dynamic>{
      "collectorId": widget.collector!.id,
      "date":
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"
    });

    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        return parsed[0]["todayCollection"] ?? 0;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<num?> todayLoanCollection() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/collector/todays-loan-collection');
    var selectedDate = DateTime.now();
    var jsonBody = jsonEncode(<String, dynamic>{
      "id": widget.collector!.id,
      "date":
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"
    });

    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        return parsed["todaysLoanCollection"] ?? 0;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<num?> getAllTimeDeposits() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        "$janaklyan/api/admin/all-time-deposits/${widget.collector!.id}");
    //final url = Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        //print(res.body);
        return parsed[0]["allTimelDeposits"]??0;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<num?> thisMonthsDeposits() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("$janaklyan/api/admin/monthly-deposits");
    //final url = Uri.parse("uri");
    final date = DateTime.now();
    var body = jsonEncode(<String, dynamic>{
      "collectorId": widget.collector!.id,
      "createdAt": "$date"
    });
    try {
      var res = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          },
          body: body);
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        return parsed[0]["deposits"] ?? 0;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.collectorId);
    var style = const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Collectors"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Option(
                label: "Collector Code ${widget.collector!.id}",
                height: 70.0,
              ),
            ],
          ),
          Row(
            children: [
              Option3(
                callback: getAllTimeDeposits,
                style: style,
                label: "All Time Deposits",
                callback2: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CollectorTransactions(widget.collector!.id),
                    ),
                  );
                },
              ),
              Option3(
                style: style,
                callback: thisMonthsDeposits,
                label: "This Month's Deposits",
                callback2: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CollectorDeposits(widget.collector!.id),
                    ),
                  );
                },
              )
            ],
          ),
          Row(
            children: [
              Option2(
                collection: widget.collector!.totalCollection,
                label: "Deposit Collection Amount in Wallet",
              ),
              Option2(
                collection: widget.collector!.totalLoanCollection,
                label: "Loan Collection Amount in Wallet",
              ),
            ],
          ),
          Row(
            children: [
              Option3(
                callback: todayCollection,
                style: style,
                label: "Today's Collection",
                callback2: () => null,
              ),
              Option3(
                style: style,
                callback: todayLoanCollection,
                label: "Today's Loan Collection",
                callback2: null
      
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Option3 extends StatelessWidget {
  final TextStyle? style;
  final TaskCallback callback;
  final TaskCallback? callback2;
  final String label;

  // ignore: prefer_const_constructors_in_immutables
  Option3(
      {Key? key,
      required this.style,
      required this.callback,
      required this.label,
      this.callback2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: () => callback2!(),
          child: Container(
            //width: screen.width * 0.34,
            height: 70,
            color: Colors.blueGrey[600],
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label.toString(),
                    style: style,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<num?>(
                      future: callback(),
                      builder: (_, snap) {
                        if (snap.hasError) {
                          return const Center(
                            child: Text("No Collectors"),
                          );
                        } else if (snap.hasData) {
                          return Text(
                            "${snap.data}",
                            style: style,
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Option2 extends StatelessWidget {
  final String? label;
  final int? collection;
  Option2({Key? key, this.collection, this.label}) : super(key: key);
  var style = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 5,
        child: Container(
          //width: screen.width * 0.34,
          height: 70,
          color: Colors.red,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label ?? "",
                  style: style,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  collection.toString(),
                  style: style,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String? label;
  final double? height;

  const Option({Key? key, this.label, this.height}) : super(key: key);
  final style = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Expanded(
      child: Card(
        elevation: 5,
        child: Container(
          //width: screen.width * 0.34,
          height: height,
          color: Colors.red,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "$label",
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
