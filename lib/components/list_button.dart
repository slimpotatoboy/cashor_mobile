import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListButton extends StatelessWidget {
  const ListButton({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.desc,
    required this.onPressed,
  });
  final String imageUrl;
  final String label;
  final String desc;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10.0),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(
                        100.0,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/$imageUrl',
                        width: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: lightStyle,
                        ),
                        Text(
                          desc,
                          style: smallStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/angleright.svg',
              width: 26,
            ),
          ],
        ),
      ),
    );
  }
}
