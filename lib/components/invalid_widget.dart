import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InvalidWidget extends StatelessWidget {
  const InvalidWidget({super.key, required this.label, required this.onScan});
  final String label;
  final Function onScan;

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: label,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: SvgPicture.asset(
                  "assets/images/invalid.svg",
                  height: 200,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SmallIconButton(
                label: "Scan",
                icon: "qr.svg",
                onPressed: () {
                  onScan();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
