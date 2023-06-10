import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EntryFieldWidget extends StatelessWidget {
  const EntryFieldWidget({
    Key? key,
    this.label,
    required this.controller,
    required this.errorText,
    required this.focusColor,
    required this.defaultColour,
    required this.hintText,
    this.readOnly = false,
    this.validation = true,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  final String? label;
  final TextEditingController controller;
  final String errorText;
  final Color focusColor;
  final Color defaultColour;
  final String hintText;
  final bool readOnly;
  final bool validation;
  final Function? onChanged;
  final FocusNode? focusNode;

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
        TextFormField(
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          validator: (value) {
            if (validation) {
              if (value == null || value.isEmpty) {
                return errorText;
              }
            }
            return null;
          },
          focusNode: focusNode,
          controller: controller,
          readOnly: readOnly,
          cursorColor: primaryColor,
          style: lightStyle,
          decoration: InputDecoration(
            hintText: hintText,
            errorStyle: errorStyle,
            hintStyle: hintStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: focusColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: primaryColor),
            ),
            filled: true,
            fillColor: greyColor,
          ),
        ),
      ],
    );
  }
}

class EmailFieldWidget extends StatelessWidget {
  const EmailFieldWidget({
    Key? key,
    this.label,
    required this.controller,
    required this.errorText,
    required this.focusColor,
    required this.defaultColour,
    required this.hintText,
    this.validation = true,
  }) : super(key: key);

  final String? label;
  final TextEditingController controller;
  final String errorText;
  final Color defaultColour;
  final Color focusColor;
  final String hintText;
  final bool validation;

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
        TextFormField(
          validator: (value) {
            if (validation) {
              if (value == null || value.isEmpty) {
                return errorText;
              }
              if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                  .hasMatch(value)) {
                return "Please enter the valid email address";
              }
            }
            return null;
          },
          controller: controller,
          cursorColor: primaryColor,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: focusColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: primaryColor),
            ),
            hintText: hintText,
            errorStyle: errorStyle,
            hintStyle: hintStyle,
            filled: true,
            fillColor: greyColor,
          ),
        ),
      ],
    );
  }
}

class PhoneNumberFieldWidget extends StatelessWidget {
  const PhoneNumberFieldWidget({
    Key? key,
    this.label,
    required this.controller,
    required this.errorText,
    required this.focusColor,
    required this.defaultColour,
    required this.hintText,
    this.validation = true,
  }) : super(key: key);

  final String? label;
  final TextEditingController controller;
  final String errorText;
  final Color focusColor;
  final Color defaultColour;
  final String hintText;
  final bool validation;

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
        TextFormField(
          validator: (value) {
            if (validation) {
              // RegExp regExp = RegExp(r'^9.*$');
              if (value == null || value.isEmpty) {
                return errorText;
                // return 'Please Enter Phone Number';
              }
              // else if (!regExp.hasMatch(value)) {
              //   return 'Please Enter Valid Phone Number';
              // }
              // else if (value.length != 10) {
              //   return 'Please Enter 10 Digit Phone Number';
              // }
            }
            return null;
          },
          controller: controller,
          cursorColor: primaryColor,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: hintText,
            errorStyle: errorStyle,
            hintStyle: hintStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: focusColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: primaryColor),
            ),
            filled: true,
            fillColor: greyColor,
          ),
        ),
      ],
    );
  }
}

class PasswordFieldWidget extends StatefulWidget {
  PasswordFieldWidget({
    Key? key,
    required this.controller,
    required this.errorText,
    required this.focusColor,
    required this.defaultColour,
    required this.isObscure,
    required this.hintText,
    this.validation = true,
    this.label,
  }) : super(key: key);

  final TextEditingController controller;
  final String errorText;
  final Color focusColor;
  final Color defaultColour;
  bool isObscure = false;
  final String hintText;
  final bool validation;
  final String? label;

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
            child: Text(widget.label!, style: lightStyle),
          ),
        TextFormField(
          validator: (value) {
            if (widget.validation) {
              if (value == null || value.isEmpty) {
                return widget.errorText;
              }
            }
            return null;
          },
          controller: widget.controller,
          cursorColor: primaryColor,
          obscureText: !widget.isObscure,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            errorStyle: errorStyle,
            hintText: widget.hintText,
            hintStyle: hintStyle,
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                widget.isObscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.black54,
                size: 20,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  widget.isObscure = !widget.isObscure;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: widget.focusColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: primaryColor),
            ),
            filled: true,
            fillColor: greyColor,
          ),
        ),
      ],
    );
  }
}

// TODO: Max Limit 1000 words
class MultiLineTextField extends StatelessWidget {
  const MultiLineTextField({
    Key? key,
    this.label,
    required this.hintText,
    required this.controller,
    required this.isValidation,
    required this.validation,
    required this.maxLines,
  }) : super(key: key);
  final String? label;
  final String hintText;
  final TextEditingController controller;
  final bool isValidation;
  final String validation;
  final int maxLines;

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
        TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: maxLines,
          maxLines: maxLines,
          style: lightStyle,
          controller: controller,
          validator: isValidation
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return validation;
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            hintStyle: hintStyle,
            hintText: hintText,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
