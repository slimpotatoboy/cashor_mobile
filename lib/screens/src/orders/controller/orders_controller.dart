import 'package:cashor_app/services/orders_service.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  final ordersService = OrdersService();
  List orders = [];

  Future fetchOrders() async {
    final result = await ordersService.fetch();
    if (result != null) {
      orders = result;
      update();
      return orders;
    }
  }
}
