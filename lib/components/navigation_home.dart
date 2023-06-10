import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/src/create_business/views/create_business_screen.dart';
import 'package:cashor_app/screens/src/home/views/home_screen.dart';
import 'package:cashor_app/screens/src/more/views/more_screen.dart';
import 'package:cashor_app/screens/src/orders/add/create_order_screen.dart';
import 'package:cashor_app/screens/src/orders/views/order_screen.dart';
import 'package:cashor_app/screens/src/products_list/single/single_product_screen.dart';
import 'package:cashor_app/screens/src/products_list/views/products_screen.dart';
import 'package:cashor_app/services/business_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NavigationHomeScreen extends StatefulWidget {
  const NavigationHomeScreen({Key? key, this.routeIndex = 0}) : super(key: key);
  final int routeIndex;

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  var currentBackPressTime = DateTime.now();
  final businessService = BusinessService();
  final storage = GetStorage();
  List business = [];
  String currentBusiness = "Your Business";

  int _selectedIndex = 0;
  List<Widget> routes = [
    const HomeScreen(),
    const OrderScreen(),
    const ProductsScreen(),
    const MoreScreen(),
  ];

  _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    currentBackPressTime = DateTime.now();
    getAllBusiness();
  }

  Future<bool> onWillPop(context) {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 3)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Press again to exit")),
      );

      return Future.value(false);
    }
    return Future.value(true);
  }

  void getAllBusiness() async {
    final result = await businessService.fetch();
    if (result.isNotEmpty) {
      business = result;
      currentBusiness = result[0].name;
      storage.write("businessId", result[0].id);
      if (result[0].permissions.contains('read("any")')) {
        storage.write("visibility", true);
      } else {
        storage.write("visibility", false);
      }
      setState(() {});
    } else {
      Get.off(() => const CreateBusinessScreen());
    }
  }

  void changeBusiness(context, item) {
    setState(() {
      currentBusiness = item.name;
    });
    Navigator.pop(context);
  }

  bool selectedBusiness(item) {
    return storage.read("businessId") == item.id ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
        ),
      ),
      body: storage.hasData('businessId')
          ? WillPopScope(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/logo11.png",
                          width: 40,
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 20.0),
                                            child: Text(
                                              "Select Business",
                                              style: boldStyle,
                                            ),
                                          ),
                                          if (business.isNotEmpty)
                                            Expanded(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: business.length,
                                                itemBuilder: (context, index) {
                                                  var item = business[index];
                                                  return businessTile(
                                                    businessName: item.name,
                                                    registrationNumber:
                                                        item.registrationNumber ??
                                                            "N/A",
                                                    onTap: () {
                                                      storage.write(
                                                          "businessId",
                                                          item.id);
                                                      changeBusiness(
                                                          context, item);
                                                    },
                                                    isActive:
                                                        selectedBusiness(item),
                                                  );
                                                },
                                              ),
                                            ),
                                          PrimaryButton(
                                            label: "Create New Business",
                                            onPress: () {
                                              Get.to(
                                                () =>
                                                    const CreateBusinessScreen(),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                currentBusiness,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/icons/arrowdown.svg',
                                color: darkGreyColor,
                                width: 24,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => const CreateOrderScreen());
                          },
                          child: SvgPicture.asset(
                            'assets/icons/cart.svg',
                            color: darkGreyColor,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: routes[_selectedIndex],
                    ),
                  )
                ],
              ),
              onWillPop: () {
                return onWillPop(context);
              },
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            builder: (_) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    InkWell(
                      onTap: () async {
                        var result = await BarcodeScanner.scan();
                        if (result.type.toString() != "Cancelled") {
                          Get.to(() => SingleProductScreen(result: result));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: greyColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(
                                      100.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/qr.svg',
                                      width: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Scan QR to Add to Cart",
                                  style: lightStyle,
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              'assets/icons/angleright.svg',
                              width: 26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: SvgPicture.asset("assets/icons/qr.svg"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF0F0F0),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: primaryColor,
        selectedIconTheme: const IconThemeData(color: primaryColor, size: 30),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(top: 15),
              child: SvgPicture.asset(
                'assets/icons/home-location.svg',
                color: _selectedIndex == 0 ? primaryColor : darkGreyColor,
                width: 26,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(top: 15),
              child: SvgPicture.asset(
                'assets/icons/orders.svg',
                color: _selectedIndex == 1 ? primaryColor : darkGreyColor,
                width: 26,
              ),
            ),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(top: 15),
              child: SvgPicture.asset(
                'assets/icons/products.svg',
                color: _selectedIndex == 2 ? primaryColor : darkGreyColor,
                width: 26,
              ),
            ),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(top: 15),
              child: SvgPicture.asset(
                'assets/icons/settings.svg',
                color: _selectedIndex == 3 ? primaryColor : darkGreyColor,
                width: 26,
              ),
            ),
            label: "More",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }

  Container businessTile(
      {required String businessName,
      required String registrationNumber,
      required Function onTap,
      bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10.0),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(
                      100.0,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/building.svg',
                      width: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      businessName,
                      style: boldStyle,
                    ),
                    Text(
                      registrationNumber,
                      style: smallStyle,
                    )
                  ],
                )
              ],
            ),
            if (isActive)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: greenColor,
                  borderRadius: BorderRadius.circular(
                    100.0,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/pin.svg',
                    width: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
