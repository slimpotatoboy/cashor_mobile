import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/empty_widget.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/src/home/controller/home_controller.dart';
import 'package:cashor_app/screens/src/home/views/add_book_screen.dart';
import 'package:cashor_app/screens/src/home/views/single_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = GetStorage();
  final HomeController homeController = Get.put(HomeController());

  // List books = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAllBooks();
    storage.listenKey('businessId', (value) {
      getAllBooks();
    });
  }

  void getAllBooks() async {
    setState(() {
      isLoading = true;
    });
    await homeController.getBooks();
    setState(() {
      isLoading = false;
      // books = result;
    });
  }

  Future<void> onRefresh() async {
    getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: isLoading
            ? const SizedBox(
                height: 400,
                child: Center(child: CircularProgressIndicator()),
              )
            : GetBuilder<HomeController>(
                builder: (ctx) {
                  final books = ctx.books;
                  return Column(
                    children: [
                      booksAppBar(),
                      if (books.isEmpty)
                        EmptyWidget(
                            label: "No Books Found", onRefresh: onRefresh),
                      if (books.isNotEmpty)
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            var item = books[index];
                            return Container(
                              margin: const EdgeInsets.only(top: 20.0),
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: greyColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                    () => SingleBookScreen(
                                      id: item.id,
                                      title: item.bookName,
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.bookName,
                                              style: boldStyle,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                "Net Balance: Rs. ${item.bookNetBalance}",
                                                style: allRedSmallTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.more_vert,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Created: ${DateFormat('MMM d y').format(item.createdAt)}",
                                        ),
                                        Text(
                                          "Updated ${timeago.format(item.updatedAt)}",
                                          style: smallBoldStyle,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Row booksAppBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Your Books",
          style: boldStyle,
        ),
        Row(
          children: [
            // TODO: add search feature
            // IconButton(
            //   onPressed: () {},
            //   icon: SvgPicture.asset("assets/icons/search.svg"),
            // ),
            SmallIconButton(
              label: "Add",
              onPressed: () async {
                final result = await Get.to(() => AddBookScreen());
                if (result != null) {
                  onRefresh();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
