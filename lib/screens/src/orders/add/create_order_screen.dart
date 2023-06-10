import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/custom_dropdown.dart';
import 'package:cashor_app/components/empty_widget.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/src/orders/controller/orders_controller.dart';
import 'package:cashor_app/services/cart_service.dart';
import 'package:cashor_app/services/orders_service.dart';
import 'package:cashor_app/services/people_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final OrdersController ordersController = Get.put(OrdersController());
  final peopleService = PeopleServices();
  final cartService = CartService();
  final orderService = OrdersService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController noteController = TextEditingController();

  List cartList = [];
  bool isLoading = true;
  bool isLoadingSubmit = false;

  String customerId = "";
  List customerList = [];

  String selectedPayment = "Credit Card";
  List paymentList = ["Credit Card", "FonePay", "Wallet"];

  String selectedOrderStatus = "Pending";
  List orderStatusList = ["Pending", "Offline"];

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  void getNewCustomer() async {
    final result = await peopleService.fetch(type: "Customer");
    customerList = result;
    isLoading = false;
    if (customerList.isNotEmpty) {
      customerId = customerList[0].id;
    }
    setState(() {});
  }

  void getCartList() async {
    cartList = [];
    final result = await cartService.fetch();
    cartList = result;
    isLoading = false;
    setState(() {});
  }

  void onChangeCustomer(value) {
    setState(() {
      customerId = value;
    });
  }

  Future<void> onRefresh() async {
    getCartList();
    getNewCustomer();
  }

  void onChangePayment(value) {
    setState(() {
      selectedPayment = value;
    });
  }

  void onChangeOrderStatus(value) {
    setState(() {
      selectedOrderStatus = value;
    });
  }

  void onSubmitNewOrder(context) async {
    setState(() {
      isLoadingSubmit = true;
    });
    // for (var item in cartList) {
    //   print(item.productId);
    // }
    final orders = await orderService.create(
      orderStatus: selectedOrderStatus.toLowerCase(),
      paymentMethod: selectedPayment,
      note: noteController.text,
      customerId: customerId,
      totalPrice: cartList
          .fold(0.0, (value, element) => value + element.totalPrice)
          .toInt(),
    );
    if (orders != null) {
      for (var item in cartList) {
        await orderService.createOrderProducts(
          orderId: orders.id,
          productId: item.productId,
          productName: item.productName,
          quantity: item.quantity,
          sellingPrice: item.sellingPrice,
          totalPrice: item.totalPrice,
        );
        await cartService.delete(item.id);
      }
    }
    isLoadingSubmit = false;
    setState(() {});
    await ordersController.fetchOrders();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: greenColor,
        content: Text("Order Created Successfully!"),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: "Create a New Order",
      child: isLoading
          ? const SizedBox(
              height: 400, child: Center(child: CircularProgressIndicator()))
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: cartList.isEmpty
                  ? EmptyWidget(
                      label: "No Cart Items",
                      onRefresh: onRefresh,
                    )
                  : SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Your Cart Items",
                                style: boldStyle,
                              ),
                            ),
                            const SizedBox(height: 15),
                            if (cartList.isNotEmpty)
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cartList.length,
                                itemBuilder: (ctx, index) {
                                  final item = cartList[index];
                                  return cartItem(item);
                                },
                              ),
                            if (cartList.isNotEmpty)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total: ",
                                    style: boldStyle,
                                  ),
                                  Text(
                                    "Rs. ${cartList.fold(0.0, (value, element) => value + element.totalPrice)} /-",
                                    style: allRedTextStyle,
                                  ),
                                ],
                              ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Divider(),
                            ),
                            const Text(
                              "Customer Details",
                              style: boldStyle,
                            ),
                            const SizedBox(height: 10),
                            CustomDropdown(
                              valueText: customerId,
                              allList: customerList.map<DropdownMenuItem>(
                                (item) {
                                  return DropdownMenuItem(
                                    value: item.id,
                                    child: Text(item.name),
                                  );
                                },
                              ).toList(),
                              onChange: onChangeCustomer,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Order Details",
                              style: boldStyle,
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8.0, left: 5.0),
                              child: Text("Payment Method", style: lightStyle),
                            ),
                            CustomDropdown(
                              valueText: selectedPayment,
                              allList: paymentList.map<DropdownMenuItem>(
                                (item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                },
                              ).toList(),
                              onChange: onChangePayment,
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8.0, left: 5.0),
                              child: Text("Order Status", style: lightStyle),
                            ),
                            CustomDropdown(
                              valueText: selectedOrderStatus,
                              allList: orderStatusList.map<DropdownMenuItem>(
                                (item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                },
                              ).toList(),
                              onChange: onChangeOrderStatus,
                            ),
                            const SizedBox(height: 20),
                            EntryFieldWidget(
                              label: "Note",
                              controller: noteController,
                              errorText: "",
                              focusColor: Colors.black54,
                              defaultColour: const Color(0xFFEBF0FF),
                              hintText: "",
                              validation: false,
                            ),
                            const SizedBox(height: 40),
                            if (!isLoadingSubmit)
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: PrimaryButton(
                                  label: "Create Order",
                                  onPress: () {
                                    if (_formKey.currentState!.validate()) {
                                      onSubmitNewOrder(context);
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
            ),
    );
  }

  Container cartItem(item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.productName,
                  style: boldStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await cartService.delete(item.id);
                  getCartList();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => whiteColor,
                  ),
                ),
                icon: const Icon(
                  Icons.delete,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          Text(
            "Rs. ${item.sellingPrice} /-",
            style: allRedSmallTextStyle,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  await cartService.udpate(
                    id: item.id,
                    quantity: item.quantity + 1,
                    totalPrice: (item.quantity + 1) * item.sellingPrice,
                  );
                  getCartList();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => whiteColor,
                  ),
                ),
                icon: SvgPicture.asset(
                  "assets/icons/plus.svg",
                  color: primaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  item.quantity.toString(),
                  style: boldStyle,
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (item.quantity > 1) {
                    await cartService.udpate(
                      id: item.id,
                      quantity: item.quantity - 1,
                      totalPrice: (item.quantity - 1) * item.sellingPrice,
                    );
                  } else {
                    await cartService.delete(item.id);
                  }
                  getCartList();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => whiteColor,
                  ),
                ),
                icon: SvgPicture.asset(
                  "assets/icons/minus.svg",
                  color: primaryColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
