import 'package:cashor_app/components/bgbutton.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.label, required this.onRefresh});
  final String label;
  final Function onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              "assets/images/empty.png",
              height: 200,
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
              label: "Refresh",
              icon: "refresh.svg",
              onPressed: () {
                onRefresh();
              },
            ),
          ],
        ),
      ),
    );
  }
}
