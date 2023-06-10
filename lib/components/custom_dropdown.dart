import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    Key? key,
    this.label,
    required this.valueText,
    required this.allList,
    required this.onChange,
  }) : super(key: key);

  final String? label;
  final String valueText;
  final List<DropdownMenuItem> allList;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
            child: Text(label!, style: lightStyle),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: greyColor,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: SvgPicture.asset("assets/icons/arrowdown.svg"),
                iconSize: 25,
                itemHeight: 57,
                // focusColor: Colors.grey.shade100,
                value: valueText,
                style: normalStyle,
                items: allList,
                onChanged: (val) {
                  onChange(val);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
