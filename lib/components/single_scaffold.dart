import 'package:cashor_app/components/custom_appbar.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:flutter/material.dart';

class SingleScaffold extends StatelessWidget {
  const SingleScaffold({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: title),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
