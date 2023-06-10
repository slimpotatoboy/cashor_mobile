import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/navigation_home.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/config.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/auth/register/views/register_screen.dart';
import 'package:cashor_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authService = AuthService();

  /// object of [TextEditingController] for email and password text field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // formkey
  final _formKey = GlobalKey<FormState>();

  // show/hide the password on eye click
  final bool isObscure = false;
  // loading state
  bool isLoading = false;

  // when user press login button
  void onLoginSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      // appwrite sdk for login in the service
      final result = await authService.login(
        email: emailController.text,
        password: passwordController.text,
      );
      setState(() {
        isLoading = false;
      });
      // when login is successful
      if (result != null) {
        emailController.clear();
        passwordController.clear();
        Get.to(() => const NavigationHomeScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cashor Logo
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
                            "Login to Continue",
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
                                EmailFieldWidget(
                                  hintText: "Email Address",
                                  controller: emailController,
                                  errorText: "Email Address is required",
                                  focusColor: Colors.black54,
                                  defaultColour: const Color(0xFFEBF0FF),
                                ),
                                const SizedBox(height: 30),
                                PasswordFieldWidget(
                                  controller: passwordController,
                                  errorText: "Password is required",
                                  focusColor: Colors.black54,
                                  defaultColour: const Color(0xFFEBF0FF),
                                  isObscure: isObscure,
                                  hintText: "Password",
                                ),
                                const SizedBox(height: 30),
                                if (!isLoading)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: PrimaryButton(
                                      label: "Login",
                                      onPress: () {
                                        onLoginSubmit();
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
                            const Text("Don't Have an Account ?"),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(
                                  () => const RegisterScreen(),
                                  duration: const Duration(milliseconds: 400),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Text(
                "Copyright ${Config.appName}",
                style: copyrightStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
