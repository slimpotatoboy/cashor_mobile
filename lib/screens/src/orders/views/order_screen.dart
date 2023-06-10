import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/empty_widget.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/src/orders/add/create_order_screen.dart';
import 'package:cashor_app/screens/src/orders/controller/orders_controller.dart';
import 'package:cashor_app/screens/src/orders/single/single_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final storage = GetStorage();
  // final ordersService = OrdersService();
  final OrdersController ordersController = Get.put(OrdersController());
  List orders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAllOrders();
    storage.listenKey('businessId', (value) {
      getAllOrders();
    });
  }

  void getAllOrders() async {
    isLoading = true;
    final result = await ordersController.fetchOrders();
    isLoading = false;
    orders = result;
    setState(() {});
  }

  Future<void> onRefresh() async {
    getAllOrders();
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
            : GetBuilder<OrdersController>(
                builder: (ctx) {
                  final orders = ctx.orders;
                  return Column(
                    children: [
                      mainAppBar(),
                      if (orders.isEmpty)
                        EmptyWidget(
                            label: "No orders Found", onRefresh: onRefresh),
                      if (orders.isNotEmpty)
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            var item = orders[index];
                            return Container(
                              margin: const EdgeInsets.only(top: 20.0),
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: greyColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final result =
                                      await Get.to(() => SingleOrderScreen(
                                            id: item.id,
                                          ));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "#${item.id}",
                                          style: normalStyle,
                                        ),
                                        const Icon(
                                          Icons.more_vert,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        top: 5.0,
                                        bottom: 10.0,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                      ),
                                      child: Text(
                                        item.orderStatus,
                                        style: smallStyle,
                                      ),
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

  Row mainAppBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Your Orders",
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
              label: "Create",
              onPressed: () async {
                final result = await Get.to(() => CreateOrderScreen());
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
