import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/navigation_home.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/services/auth_service.dart';
import 'package:cashor_app/services/business_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final authService = AuthService();

  /// object of [TextEditingController] for phone and password text field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registrationNumberController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();

  final businessService = BusinessService();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void createBusiness(context) async {
    setState(() {
      isLoading = true;
    });
    await businessService.create(
      name: nameController.text,
      registrationNumber: registrationNumberController.text,
      businessEmail: emailController.text,
      businessPhone: phoneController.text,
      bankAccount: bankAccountController.text,
    );
    setState(() {
      isLoading = false;
    });
    nameController.clear();
    registrationNumberController.clear();
    emailController.clear();
    phoneController.clear();
    bankAccountController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: greenColor,
        content: Text("Business Created Successfully"),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Get.off(() => const NavigationHomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: "Create Business",
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Column(
                    children: [
                      EntryFieldWidget(
                        label: "Business Name",
                        hintText: "Enter Your Business Name",
                        controller: nameController,
                        errorText: "Business Name is required",
                        focusColor: Colors.black54,
                        defaultColour: const Color(0xFFEBF0FF),
                      ),
                      const SizedBox(height: 20),
                      EntryFieldWidget(
                        label: "Business Registration Number",
                        hintText: "Enter PAN/VAT/Registration Number",
                        controller: registrationNumberController,
                        errorText: "Registration Number is required",
                        focusColor: Colors.black54,
                        defaultColour: const Color(0xFFEBF0FF),
                      ),
                      const SizedBox(height: 20),
                      EmailFieldWidget(
                        label: "Business Email",
                        hintText: "Business Email",
                        controller: emailController,
                        errorText: "Email Address is required",
                        focusColor: Colors.black54,
                        defaultColour: const Color(0xFFEBF0FF),
                      ),
                      const SizedBox(height: 20),
                      PhoneNumberFieldWidget(
                        label: "Business Phone Number",
                        controller: phoneController,
                        errorText: "Password is required",
                        focusColor: Colors.black54,
                        defaultColour: const Color(0xFFEBF0FF),
                        hintText: "Business Phone Number",
                      ),
                      const SizedBox(height: 20),
                      EntryFieldWidget(
                        label: "Bank Account",
                        hintText: "Enter Your Bank Account",
                        controller: bankAccountController,
                        errorText: "Bank Account Name is required",
                        focusColor: Colors.black54,
                        defaultColour: const Color(0xFFEBF0FF),
                      ),
                      const SizedBox(height: 30),
                      if (isLoading)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: GreyIconButton(
                            label: "Loading...",
                            onPressed: () {},
                          ),
                        ),
                      if (!isLoading)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: PrimaryButton(
                            label: "Submit",
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                createBusiness(context);
                              }
                            },
                          ),
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
