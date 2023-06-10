import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/models/books_model.dart';
import 'package:cashor_app/screens/src/home/controller/home_controller.dart';
import 'package:cashor_app/screens/src/home/views/add_single_book_screen.dart';
import 'package:cashor_app/services/auth_service.dart';
import 'package:cashor_app/services/books_service.dart';
import 'package:cashor_app/services/inner_books_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleBookScreen extends StatefulWidget {
  const SingleBookScreen({
    super.key,
    required this.id,
    required this.title,
  });
  final String id;
  final String title;

  @override
  State<SingleBookScreen> createState() => _SingleBookScreenState();
}

class _SingleBookScreenState extends State<SingleBookScreen> {
  final innerBooksService = InnerBooksService();
  final booksService = BooksService();
  final authService = AuthService();
  final storage = GetStorage();
  List innerBooks = [];
  late Books singleBook;
  bool isLoading = false;
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    getAllInnerBooks();
  }

  void getAllInnerBooks() async {
    setState(() {
      isLoading = true;
    });
    final singleBookValue = await booksService.get(widget.id);
    final result = await innerBooksService.fetch(widget.id);
    setState(() {
      isLoading = false;
      singleBook = singleBookValue;
      innerBooks = result;
    });
  }

  Future<void> onRefresh() async {
    getAllInnerBooks();
    await homeController.getBooks();
  }

  // to get who updated
  String updatedBy(item) {
    if (storage.read('userId') == item.updatedBy) {
      return "You";
    } else {
      return "Other";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: widget.title,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.26,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          topContainer(),
                          const SizedBox(height: 15),
                          if (innerBooks.isNotEmpty)
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: innerBooks.length,
                              itemBuilder: (context, index) {
                                var item = innerBooks[index];
                                return bookEntry(item);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15.0),
                    color: whiteColor,
                    child: Column(
                      children: [
                        if (innerBooks.isEmpty)
                          const Text(
                            "Try adding your first entry",
                            style: titleStyle,
                          ),
                        if (innerBooks.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child:
                                SvgPicture.asset("assets/icons/arrowdown.svg"),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: PrimaryButton(
                                  label: "CASH IN",
                                  icon: "plus",
                                  color: greenColor,
                                  onPress: () async {
                                    final result = await Get.to(
                                      () => AddSingleBookScreen(
                                        booksId: widget.id,
                                        category: "Cash In",
                                        netBalance: singleBook.bookNetBalance,
                                        netCashIn: singleBook.totalCashIn,
                                        netCashOut: singleBook.totalCashOut,
                                      ),
                                    );
                                    if (result != null) {
                                      onRefresh();
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: PrimaryButton(
                                  label: "Cash Out",
                                  icon: "minus",
                                  onPress: () async {
                                    final result = await Get.to(
                                      () => AddSingleBookScreen(
                                        booksId: widget.id,
                                        category: "Cash Out",
                                        netBalance: singleBook.bookNetBalance,
                                        netCashIn: singleBook.totalCashIn,
                                        netCashOut: singleBook.totalCashOut,
                                      ),
                                    );
                                    if (result != null) {
                                      onRefresh();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Container bookEntry(item) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.remarks),
              Text("Balance: ${item.balance}"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rs. ${item.cashIn != 0 ? item.cashIn : item.cashOut}",
                style: TextStyle(
                  color: item.cashIn != 0 ? greenColor : primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (item.type != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 15.0,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    "Orders",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              children: List.generate(
                150 ~/ 2,
                (index) => Expanded(
                  child: Container(
                    color: index % 2 == 0
                        ? Colors.transparent
                        : Colors.grey.shade500,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          Text(
            "Updated by ${updatedBy(item)} ${timeago.format(item.createdAt)} ",
            style: smallStyle,
          ),
          const SizedBox(height: 5),
          Text(
            DateFormat('y MMM d').format(item.createdAt),
            style: smallStyle,
          ),
        ],
      ),
    );
  }

  Container topContainer() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Net Balance", style: boldStyle),
              Text("Rs. ${singleBook.bookNetBalance}"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              children: List.generate(
                150 ~/ 2,
                (index) => Expanded(
                  child: Container(
                    color: index % 2 == 0
                        ? Colors.transparent
                        : Colors.grey.shade500,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Cash In", style: boldStyle),
              Text(
                "Rs. ${singleBook.totalCashIn}",
                style: const TextStyle(
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Cash Out", style: boldStyle),
              Text(
                "Rs. ${singleBook.totalCashOut}",
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
