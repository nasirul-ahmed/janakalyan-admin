import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/loan_application_model.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:janakalyan_admin/utils/parse_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanApplication extends StatelessWidget {
  const LoanApplication({Key? key}) : super(key: key);
  Future<List<LoanApplicationModel>> pendingLoanApplication() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/loan-application');
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
            .map<LoanApplicationModel>(
                (json) => LoanApplicationModel.fromJson(json))
            .toList();
      }
      return List<LoanApplicationModel>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<LoanApplicationModel>> processLoanApplication() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/approved-loan-application');
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
            .map<LoanApplicationModel>(
                (json) => LoanApplicationModel.fromJson(json))
            .toList();
      }
      return List<LoanApplicationModel>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Application"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.45,
                  color: Colors.blueGrey[600],
                  child: Center(
                    child: Text("Pending Loan Application", style: style),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.45,
                  color: Colors.blueGrey[600],
                  child: Center(
                    child: Text(
                      "Proccessing Loan Application",
                      style: style,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: CustomLoanApplication(
                callback: pendingLoanApplication,
              )),
              Expanded(
                  child: CustomLoanApplication(
                callback: processLoanApplication,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomLoanApplication extends StatelessWidget {
  final TaskCallback callback;
  const CustomLoanApplication({Key? key, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LoanApplicationModel>>(
      future: callback(),
      builder: (_, snap) {
        if (snap.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else if (snap.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snap.data!.length,
              itemBuilder: (_, id) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: snap.data![id].isSanctioned != 1
                        ? Text(
                            "${snap.data![id].custName} (C.code- ${snap.data![id].collectorId.toString()})")
                        : Text(
                            "${snap.data![id].custName} (A/C- ${snap.data![id].depositAcNo}) (C.code- ${snap.data![id].collectorId})"),
                    subtitle: snap.data![id].isSanctioned != 1
                        ? Text("A/C: ${snap.data![id].depositAcNo}")
                        : Text(
                            "Sanction Date: ${formatDate(snap.data![id].processDate)}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "Applied Loan Amount: ${snap.data![id].loanAmount}"),
                        Text(
                            "Applied Date: ${formatDate(snap.data![id].createdAt)} "),
                      ],
                    ),
                  ),
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
