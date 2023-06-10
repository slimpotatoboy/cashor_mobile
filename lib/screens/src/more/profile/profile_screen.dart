import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  String email = "";
  bool isLoadingSubmit = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    final result = await authService.getUser();
    nameController.text = result.name.toString();
    email = result.email.toString();
    setState(() {});
  }

  void submitProfile(context) async {
    setState(() {
      isLoadingSubmit = true;
    });
    await authService.updateName(nameController.text);
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
                label: "Name",
                controller: nameController,
                errorText: "Name is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                hintText: "",
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0, left: 5.0),
                    child: Row(
                      children: [
                        Text("Email", style: lightStyle),
                        SizedBox(width: 8),
                        Text(
                          "(Read Only)",
                          style: allRedSmallTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      email,
                      style: lightStyle,
                    ),
                  ),
                ],
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
