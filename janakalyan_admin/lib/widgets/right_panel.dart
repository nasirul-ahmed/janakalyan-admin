import 'package:flutter/material.dart';
import 'package:janakalyan_admin/screen/cashbook/cashbook.dart';
import 'package:janakalyan_admin/screen/collector/collector_details.dart';
import 'package:janakalyan_admin/screen/deposit_history/deposit_history.dart';
import 'package:janakalyan_admin/screen/loan_application/loan_application.dart';
import 'package:janakalyan_admin/screen/loan_deposit/loan_deposit_history.dart';

class RightPanel extends StatefulWidget {
  const RightPanel({Key? key}) : super(key: key);

  @override
  _RightPanelState createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DepositHistory()));
                },
                child: const Ooptions(
                    label: "Deposit Collection", rupees: "12333")),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoanDepositHistory()));
                },
                child:
                    const Ooptions(label: "Loan Collection", rupees: "12333")),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CollectorDetails()));
              },
              child: Ooptions2(
                label: "Collector Details",
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Cashbook()));
              },
              child: Ooptions2(
                label: "Cashbook",
              ),
            ),
          ],
        ),

        // InkWell(
        //   child: Ooptions2(label: "Loan Application",),
        // )
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => LoanApplication()));
              },
              child: Ooptions2(
                label: "Loan Application",
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Cashbook()));
              },
              child: Ooptions2(
                label: "Loan Details",
              ),
            ),
          ],
        )
      ],
    );
  }
}

class Ooptions extends StatelessWidget {
  final String? label;
  final String? rupees;
  const Ooptions({Key? key, @required this.label, this.rupees})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600);
    return Card(
      elevation: 5,
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width * 0.34,
        color: Colors.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$label",
              style: style,
            ),
            SizedBox(height: 10),
            Text(
              "RS. $rupees",
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}

class Ooptions2 extends StatelessWidget {
  final String? label;

  const Ooptions2({Key? key, this.label}) : super(key: key);
  final style = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      child: Container(
        width: screen.width * 0.34,
        height: 60.0,
        color: Colors.red,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "$label",
            style: style,
          ),
        ),
      ),
    );
  }
}
