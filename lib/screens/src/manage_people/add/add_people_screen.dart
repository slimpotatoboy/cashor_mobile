import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/constants.dart';
import 'package:cashor_app/services/people_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPeopleScreen extends StatefulWidget {
  const AddPeopleScreen({
    super.key,
    required this.person,
  });
  final People person;

  @override
  State<AddPeopleScreen> createState() => _AddPeopleScreenState();
}

class _AddPeopleScreenState extends State<AddPeopleScreen> {
  final peopleService = PeopleServices();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = false;
  late People selectedPeople;

  @override
  void initState() {
    super.initState();
    selectedPeople = widget.person;
  }

  void onAddPeople(context) async {
    setState(() {
      isLoading = true;
    });

    await peopleService.create(
      name: fullNameController.text,
      phone: phoneController.text,
      email: emailController.text,
      address: addressController.text,
      type: selectedPeople == People.customers ? 'Customer' : 'Supplier',
    );

    setState(() {
      isLoading = false;
    });

    fullNameController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();

    Get.back(result: "Hello");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: greenColor,
        content: Text("Added Successfully"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title:
          "Add ${selectedPeople == People.customers ? 'Customers' : 'Suppliers'}",
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              EntryFieldWidget(
                label: "Full Name",
                controller: fullNameController,
                errorText: "Full Name is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                hintText: "Enter Full Name",
              ),
              const SizedBox(height: 20),
              PhoneNumberFieldWidget(
                label: "Phone",
                controller: phoneController,
                errorText: "Phone is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                hintText: "Enter Phone Number",
                validation: false,
              ),
              const SizedBox(height: 20),
              EmailFieldWidget(
                label: "Email",
                controller: emailController,
                errorText: "Email is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                hintText: "Enter Email Address",
                validation: false,
              ),
              const SizedBox(height: 20),
              EntryFieldWidget(
                label: "Address",
                controller: addressController,
                errorText: "Address is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                hintText: "Enter Address",
                validation: false,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ActionChip(
                    onPressed: () {
                      setState(() {
                        selectedPeople = People.customers;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    side: BorderSide(
                      width: 0,
                      color: selectedPeople == People.customers
                          ? primaryColor
                          : Colors.black45,
                    ),
                    backgroundColor: selectedPeople == People.customers
                        ? primaryColor
                        : whiteColor,
                    labelStyle: TextStyle(
                      color: selectedPeople == People.customers
                          ? whiteColor
                          : Colors.black87,
                    ),
                    label: const Text("Customer"),
                  ),
                  const SizedBox(width: 10),
                  ActionChip(
                    onPressed: () {
                      setState(() {
                        selectedPeople = People.suppliers;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    side: BorderSide(
                      width: 0,
                      color: selectedPeople == People.suppliers
                          ? primaryColor
                          : Colors.black45,
                    ),
                    backgroundColor: selectedPeople == People.suppliers
                        ? primaryColor
                        : whiteColor,
                    labelStyle: TextStyle(
                      color: selectedPeople == People.suppliers
                          ? whiteColor
                          : Colors.black87,
                    ),
                    label: const Text("Suppliers"),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              if (isLoading)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: GreyIconButton(
                    onPressed: () {},
                    label: "Loading...",
                  ),
                ),
              if (!isLoading)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: PrimaryButton(
                    label: "Add",
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        onAddPeople(context);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
