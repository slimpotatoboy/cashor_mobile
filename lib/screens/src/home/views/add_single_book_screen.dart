import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/screens/src/home/controller/home_controller.dart';
import 'package:cashor_app/services/books_service.dart';
import 'package:cashor_app/services/inner_books_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AmountCategory {
  cashIn,
  cashOut,
}

class AddSingleBookScreen extends StatefulWidget {
  const AddSingleBookScreen({
    super.key,
    required this.booksId,
    required this.category,
    required this.netBalance,
    required this.netCashIn,
    required this.netCashOut,
  });
  final String booksId;
  final String category;
  final dynamic netBalance;
  final dynamic netCashIn;
  final dynamic netCashOut;

  @override
  State<AddSingleBookScreen> createState() => _AddSingleBookScreenState();
}

class _AddSingleBookScreenState extends State<AddSingleBookScreen> {
  final HomeController homeController = Get.put(HomeController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final innerBooksService = InnerBooksService();
  final booksService = BooksService();
  bool isLoading = false;
  late AmountCategory selectedCategory;

  @override
  void initState() {
    super.initState();
    // select cash
    selectedCategory = widget.category == "Cash In"
        ? AmountCategory.cashIn
        : AmountCategory.cashOut;
  }

  // on book update
  void onBookUpdate(
      {required dynamic netBalance,
      required dynamic netCashIn,
      required dynamic netCashOut}) async {
    await homeController.getBooks();
    await booksService.udpate(
      id: widget.booksId,
      bookNetBalance: netBalance,
      totalCashIn: netCashIn,
      totalCashOut: netCashOut,
    );
  }

  // on add book entry
  void onAddBookEntry(context) async {
    setState(() {
      isLoading = true;
    });

    dynamic totalBalance = widget.netBalance;
    dynamic mainCashIn = widget.netCashIn;
    dynamic mainCashOut = widget.netCashOut;
    if (selectedCategory == AmountCategory.cashIn) {
      totalBalance += double.parse(amountController.text);
      mainCashIn += double.parse(amountController.text);
    }
    if (selectedCategory == AmountCategory.cashOut) {
      totalBalance -= double.parse(amountController.text);
      mainCashOut += double.parse(amountController.text);
    }

    onBookUpdate(
      netBalance: totalBalance,
      netCashIn: mainCashIn,
      netCashOut: mainCashOut,
    );

    await innerBooksService.create(
      booksId: widget.booksId,
      remarks: remarksController.text,
      balance: totalBalance,
      cashIn: selectedCategory == AmountCategory.cashIn
          ? int.parse(amountController.text)
          : 0,
      cashOut: selectedCategory == AmountCategory.cashOut
          ? int.parse(amountController.text)
          : 0,
    );

    setState(() {
      isLoading = false;
    });
    remarksController.clear();
    amountController.clear();
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
      title: selectedCategory == AmountCategory.cashIn ? "Cash In" : "Cash Out",
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  ActionChip(
                    onPressed: () {
                      setState(() {
                        selectedCategory = AmountCategory.cashIn;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    side: BorderSide(
                      width: 0,
                      color: selectedCategory == AmountCategory.cashIn
                          ? greenColor
                          : Colors.black45,
                    ),
                    backgroundColor: selectedCategory == AmountCategory.cashIn
                        ? greenColor
                        : whiteColor,
                    labelStyle: TextStyle(
                      color: selectedCategory == AmountCategory.cashIn
                          ? whiteColor
                          : Colors.black87,
                    ),
                    label: const Text("Cash In"),
                  ),
                  const SizedBox(width: 10),
                  ActionChip(
                    onPressed: () {
                      setState(() {
                        selectedCategory = AmountCategory.cashOut;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    side: BorderSide(
                      width: 0,
                      color: selectedCategory == AmountCategory.cashOut
                          ? primaryColor
                          : Colors.black45,
                    ),
                    backgroundColor: selectedCategory == AmountCategory.cashOut
                        ? primaryColor
                        : whiteColor,
                    labelStyle: TextStyle(
                      color: selectedCategory == AmountCategory.cashOut
                          ? whiteColor
                          : Colors.black87,
                    ),
                    label: const Text("Cash Out"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              EntryFieldWidget(
                label: "Remarks",
                controller: remarksController,
                errorText: "Remarks is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                hintText: "Enter Your Remarks",
              ),
              const SizedBox(height: 20),
              EntryFieldWidget(
                label: "Amount",
                controller: amountController,
                errorText: "Amount is required",
                focusColor: Colors.black54,
                defaultColour: const Color(0xFFEBF0FF),
                hintText: "Enter Amount",
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
                        onAddBookEntry(context);
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
