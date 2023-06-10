import 'package:cashor_app/components/empty_widget.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/constants.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/src/manage_people/add/add_people_screen.dart';
import 'package:cashor_app/services/people_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ManagePeopleScreen extends StatefulWidget {
  const ManagePeopleScreen({super.key});

  @override
  State<ManagePeopleScreen> createState() => _ManagePeopleScreenState();
}

class _ManagePeopleScreenState extends State<ManagePeopleScreen> {
  final peopleService = PeopleServices();

  List customers = [];
  List suppliers = [];
  bool isLoading = false;

  // indicates which tab is selected
  int selectedTab = 0;
  // list of all the tabs
  final List tabs = [
    "Customers",
    "Suppliers",
  ];

  @override
  void initState() {
    super.initState();
    getAllBooks();
  }

  void getAllBooks() async {
    setState(() {
      customers = [];
      suppliers = [];
      isLoading = true;
    });
    final result = await peopleService.fetch();
    setState(() {
      isLoading = false;
    });

    for (var item in result) {
      if (item.type == "Customer") {
        customers.add(item);
      }
      if (item.type == "Supplier") {
        suppliers.add(item);
      }
      setState(() {});
    }
  }

  Future<void> onRefresh() async {
    getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: selectedTab,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                selectedTab = index;
              });
            },
            tabs: tabs.map((e) => Tab(text: e.toString())).toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Get.to(() => AddPeopleScreen(
                person:
                    selectedTab == 0 ? People.customers : People.suppliers));
            if (result != null) {
              onRefresh();
            }
          },
          child: SvgPicture.asset(
            "assets/icons/plus.svg",
            width: 24,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            containerWrap(customers),
            containerWrap(suppliers),
          ],
        ),
      ),
    );
  }

  Widget containerWrap(List data) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (data.isEmpty) {
        return EmptyWidget(label: "No data Found", onRefresh: onRefresh);
      } else {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var item = data[index];
              return Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: boldStyle),
                    if (item.phone != "")
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(item.phone, style: lightStyle),
                      ),
                    if (item.email != "")
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(item.email, style: lightStyle),
                      ),
                    if (item.address != "")
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(item.address, style: lightStyle),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                          "Created Date: ${DateFormat('d MMM y').format(item.createdAt)}",
                          style: lightStyle),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    }
  }
}
