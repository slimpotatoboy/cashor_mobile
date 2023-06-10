import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/services/business_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final businessService = BusinessService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registrationNumberController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();

  bool isLoadingSubmit = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    final result = await businessService.get();
    nameController.text = result.name.toString();
    registrationNumberController.text = result.registrationNumber ?? "";
    emailController.text = result.businessEmail ?? "";
    phoneController.text = result.businessPhone ?? "";
    bankAccountController.text = result.bankAccount ?? "";

    setState(() {});
  }

  void submitProfile(context) async {
    setState(() {
      isLoadingSubmit = true;
    });
    await businessService.update(
      name: nameController.text,
      registrationNumber: registrationNumberController.text,
      businessEmail: emailController.text,
      businessPhone: phoneController.text,
      bankAccount: bankAccountController.text,
    );
    setState(() {
      isLoadingSubmit = false;
    });
    Get.back();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: greenColor,
        content: Text("Profile Updated Successfully!"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: "Profile",
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                hintText: "PAN/VAT/Registration",
                controller: registrationNumberController,
                errorText: "Registration Number is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                validation: false,
              ),
              const SizedBox(height: 20),
              EmailFieldWidget(
                label: "Business Email",
                hintText: "business@cashor.com",
                controller: emailController,
                errorText: "Email Address is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                validation: false,
              ),
              const SizedBox(height: 20),
              PhoneNumberFieldWidget(
                label: "Business Phone Number",
                controller: phoneController,
                errorText: "Password is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                hintText: "Business Phone Number",
                validation: false,
              ),
              const SizedBox(height: 20),
              EntryFieldWidget(
                label: "Bank Account",
                hintText: "Enter Your Bank Account",
                controller: bankAccountController,
                errorText: "Bank Account Name is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                validation: false,
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
