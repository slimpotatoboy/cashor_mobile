import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/services/books_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final booksService = BooksService();
  final TextEditingController addbookController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // when user press add book
  void onAddBook(context) async {
    setState(() {
      isLoading = true;
    });
    await booksService.create(bookName: addbookController.text);
    setState(() {
      isLoading = false;
    });
    addbookController.clear();
    Get.back(result: "Return");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: greenColor,
        content: Text("Book Created Successfully"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: "Add Book",
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              EntryFieldWidget(
                controller: addbookController,
                errorText: "Book Name is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                hintText: "Book Name",
              ),
              const SizedBox(height: 50),
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
                    label: "Add",
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        onAddBook(context);
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
