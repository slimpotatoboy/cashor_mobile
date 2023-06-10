import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onPress,
    this.icon,
    this.color = primaryColor,
  }) : super(key: key);
  final String label;
  final Function onPress;
  final String? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        backgroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      onPressed: () {
        onPress();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: SvgPicture.asset(
                "assets/icons/$icon.svg",
                color: whiteColor,
              ),
            ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class SmallIconButton extends StatelessWidget {
  const SmallIconButton({
    Key? key,
    required this.label,
    this.icon = "plus.svg",
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final String icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/$icon",
              color: whiteColor,
              width: 16,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GreyIconButton extends StatelessWidget {
  const GreyIconButton(
      {super.key, required this.label, this.icon, required this.onPressed});

  final String label;
  final String? icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: greyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) SvgPicture.asset("assets/icons/$icon.svg"),
          const SizedBox(width: 10),
          Text(
            label,
            style: lightStyle,
          ),
        ],
      ),
    );
  }
}
