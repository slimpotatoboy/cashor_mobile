import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final bool isObscure = false;
  final bool newPasswordObscure = false;
  final bool confirmPasswordObscure = false;
  bool isLoadingSubmit = false;

  void submitProfile(context) async {
    setState(() {
      isLoadingSubmit = true;
    });
    final result = await authService.updatePassword(
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
    );
    setState(() {
      isLoadingSubmit = false;
    });
    if (result != null) {
      print(result.code);
    }
    // Get.back();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     backgroundColor: greenColor,
    //     content: Text("Profile Updated Successfully!"),
    //     behavior: SnackBarBehavior.floating,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: "Change Password",
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              PasswordFieldWidget(
                controller: oldPasswordController,
                errorText: "Old Password is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                isObscure: isObscure,
                hintText: "Old Password",
              ),
              const SizedBox(height: 20),
              PasswordFieldWidget(
                controller: newPasswordController,
                errorText: "New Password is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                isObscure: newPasswordObscure,
                hintText: "New Password",
              ),
              const SizedBox(height: 20),
              PasswordFieldWidget(
                controller: confirmPasswordController,
                errorText: "Confirm New Password is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                isObscure: confirmPasswordObscure,
                hintText: "Confirm New Password",
              ),
              const SizedBox(height: 40),
              if (!isLoadingSubmit)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: PrimaryButton(
                    label: "Submit",
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        submitProfile(context);
                      }
                    },
                  ),
                ),
              if (isLoadingSubmit)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: GreyIconButton(
                    label: "Loading...",
                    onPressed: () {},
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
