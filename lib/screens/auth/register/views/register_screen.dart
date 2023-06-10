import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/config.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/src/create_business/views/create_business_screen.dart';
import 'package:cashor_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authService = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final bool isObscure = false;
  final bool isObscureConfirm = false;
  bool isChecked = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return greyColor;
      }
      return primaryColor;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/logo11.png",
                    width: 150,
                  ),
                  const Text(
                    "For Business",
                    style: allRedTextStyle,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
                    child: Text(
                      "Sign Up to Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30.0,
                      ),
                      child: Column(
                        children: [
                          EntryFieldWidget(
                            label: "Full Name",
                            hintText: "Full Name",
                            controller: nameController,
                            errorText: "Full Name is required",
                            focusColor: Colors.black54,
                            defaultColour: const Color(0xFFEBF0FF),
                          ),
                          const SizedBox(height: 30),
                          EmailFieldWidget(
                            label: "Email Address",
                            hintText: "Email Address",
                            controller: emailController,
                            errorText: "Email Address is required",
                            focusColor: Colors.black54,
                            defaultColour: const Color(0xFFEBF0FF),
                          ),
                          const SizedBox(height: 30),
                          PasswordFieldWidget(
                            label: "Password",
                            controller: passwordController,
                            errorText: "Password is required",
                            focusColor: Colors.black54,
                            defaultColour: const Color(0xFFEBF0FF),
                            isObscure: isObscure,
                            hintText: "Password",
                          ),
                          const SizedBox(height: 30),
                          PasswordFieldWidget(
                            label: "Confirm Password",
                            controller: confirmPasswordController,
                            errorText: "Confirm Password is required",
                            focusColor: Colors.black54,
                            defaultColour: const Color(0xFFEBF0FF),
                            isObscure: isObscureConfirm,
                            hintText: "Confirm Password",
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text(
                                    "I accept the terms and conditions of Cashor Business"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          if (!isLoading)
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: PrimaryButton(
                                label: "Sign Up",
                                onPress: () async {
                                  // validation of the form
                                  if (_formKey.currentState!.validate()) {
                                    if (!isChecked) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            backgroundColor: primaryColor,
                                            content: Text(
                                                "Please accept the terms and conditions")),
                                      );
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final result = await authService.signUp(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (result != null) {
                                        nameController.clear();
                                        emailController.clear();
                                        passwordController.clear();
                                        Get.to(
                                            () => const CreateBusinessScreen());
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          if (isLoading)
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: GreyIconButton(
                                label: "Loading...",
                                onPressed: () {},
                              ),
                            ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already Have an Account ?"),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Copyright ${Config.appName}",
                    style: copyrightStyle,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
