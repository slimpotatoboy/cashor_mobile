import 'package:cashor_app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset("assets/icons/leftangle.svg"),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: titleStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 50)
        ],
      ),
    );
  }
}
