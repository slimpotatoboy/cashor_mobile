import 'package:cashor_app/components/custom_dropdown.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/models/orders_model.dart';
import 'package:cashor_app/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class SingleOrderScreen extends StatefulWidget {
  const SingleOrderScreen({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<SingleOrderScreen> createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen> {
  final orderService = OrdersService();
  List orders = [];
  late Orders singleOrder;
  List orderProducts = [];
  bool isLoading = false;

  String selectedOrderStatus = "Pending";
  List orderStatusList = [
    "Pending",
    "Delivered",
    "Returned",
    "Offline",
    "Onhold"
  ];

  void onChangeOrderStatus(value) async {
    setState(() {
      selectedOrderStatus = value;
    });
    await orderService.updateOrderStatus(
      id: widget.id,
      orderStatus: value.toString().toLowerCase(),
    );
    getSingleOrder();
  }

  @override
  void initState() {
    super.initState();
    getSingleOrder();
  }

  void getSingleOrder() async {
    setState(() {
      isLoading = true;
    });
    final singleOrderValue = await orderService.get(widget.id);
    final singleOrderProduct = await orderService.fetchOrderProduct(widget.id);
    setState(() {
      isLoading = false;
      singleOrder = singleOrderValue;
      orderProducts = singleOrderProduct;
      selectedOrderStatus =
          singleOrderValue.orderStatus.toString().capitalize();
    });
  }

  Future<void> onRefresh() async {
    getSingleOrder();
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: "View Order",
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (singleOrder.orderStatus == "offline")
                      Column(
                        children: [
                          SizedBox(
                              width: 32,
                              height: 32,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  color: Colors.green,
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/tick.svg",
                                  color: Colors.white,
                                ),
                              )),
                          const SizedBox(height: 10),
                          const Text("Offline")
                        ],
                      ),
                    if (singleOrder.orderStatus == "pending" ||
                        singleOrder.orderStatus == "delivered" ||
                        singleOrder.orderStatus == "returned" ||
                        singleOrder.orderStatus == "onhold")
                      trackMethod(),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    SelectableText(
                      "Order Id: #${singleOrder.id}",
                      style: lightStyle,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Payment Method: ${singleOrder.paymentMethod}",
                      style: lightStyle,
                    ),
                    const SizedBox(height: 10),
                    SelectableText(
                      "Note: ${singleOrder.note}",
                      style: lightStyle,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Created: ${DateFormat('MMM d y ').format(singleOrder.createdAt!)}",
                      style: lightStyle,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Updated ${timeago.format(singleOrder.updatedAt!)}",
                      style: lightStyle,
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Products", style: boldStyle),
                        const SizedBox(height: 10),
                        if (orderProducts.isNotEmpty)
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderProducts.length,
                            itemBuilder: (context, index) {
                              var item = orderProducts[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 15.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Rs. ${item.sellingPrice} /-",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Quantity: ${item.quantity}",
                                            style: smallStyle,
                                          ),
                                          const SizedBox(height: 2),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Change Order Status",
                            style: lightStyle,
                          ),
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
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Padding trackMethod() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                  width: 32,
                  height: 32,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      color: singleOrder.orderStatus == "pending" ||
                              singleOrder.orderStatus == "returned" ||
                              singleOrder.orderStatus == "delivered" ||
                              singleOrder.orderStatus == "onhold"
                          ? Colors.green
                          : Colors.grey,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/tick.svg",
                      color: Colors.white,
                    ),
                  ) // This trailing comma makes auto-formatting nicer for build methods.
                  ),
              const SizedBox(
                height: 10,
              ),
              const Text("Pending")
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            width: 80,
            height: 1,
            child: ClipRRect(
              child: Container(
                color: singleOrder.orderStatus == "delivered"
                    ? Colors.green
                    : Colors.grey,
              ),
            ),
          ),
          if (singleOrder.orderStatus == "returned" ||
              singleOrder.orderStatus == "onhold")
            Column(
              children: [
                SizedBox(
                    width: 32,
                    height: 32,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        color: Colors.green,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/tick.svg",
                        color: Colors.white,
                      ),
                    )),
                const SizedBox(height: 10),
                Text(singleOrder.orderStatus.toString().capitalize()),
              ],
            ),
          if (singleOrder.orderStatus == "returned" ||
              singleOrder.orderStatus == "onhold")
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: 80,
              height: 1,
              child: ClipRRect(
                child: Container(
                  color: singleOrder.orderStatus == "delivered"
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ),
          Column(
            children: [
              SizedBox(
                  width: 32,
                  height: 32,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      color: singleOrder.orderStatus == "delivered"
                          ? Colors.green
                          : Colors.grey,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/tick.svg",
                      color: Colors.white,
                    ),
                  ) // This trailing comma makes auto-formatting nicer for build methods.
                  ),
              const SizedBox(
                height: 10,
              ),
              const Text("Delivered")
            ],
          ),
        ],
      ),
    );
  }
}
