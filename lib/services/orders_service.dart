import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/config/logger.dart';
import 'package:cashor_app/models/orders_model.dart';
import 'package:cashor_app/models/order_product_model.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/config/constants.dart' as constants;
import 'package:cashor_app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

class OrdersService {
  final Databases _databases = Databases(Appwrite.instance.client);
  final authService = AuthService();
  final storage = GetStorage();

  // create new order
  Future create({
    required String orderStatus,
    required String paymentMethod,
    required String note,
    required String customerId,
    required int totalPrice,
  }) async {
    var id = ID.unique();
    final orders = await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.ordersCollectionId,
      documentId: id,
      data: {
        "business_id": storage.read('businessId'),
        "order_status": orderStatus,
        "payment_method": paymentMethod,
        "note": note,
        "updated_by": await authService.getAccountId(),
        "customer_id": customerId,
        "total_price": totalPrice,
      },
    );
    return Orders.fromMap(orders.data);
  }

  // fetch orders
  Future fetch() async {
    try {
      final ordersList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.ordersCollectionId,
        queries: [
          Query.equal(
            "business_id",
            storage.read("businessId"),
          ),
          Query.orderDesc("\$id")
        ],
      );
      return ordersList.documents.map((e) => Orders.fromMap(e.data)).toList();
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Orders Fetch all of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  // get single order details
  Future get(String id) async {
    try {
      final booksList = await _databases.getDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.ordersCollectionId,
        documentId: id,
        queries: [
          Query.equal(
            "business_id",
            storage.read("businessId"),
          ),
        ],
      );
      return Orders.fromMap(booksList.data);
    } on AppwriteException catch (e) {
      DiscordLog()
          .log("Order Get of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  // fetch order products
  Future fetchOrderProduct(String orderId) async {
    try {
      final productList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.ordersProductCollectionId,
        queries: [
          Query.equal(
            "order_id",
            orderId,
          ),
          Query.orderDesc("\$id")
        ],
      );
      return productList.documents
          .map((e) => OrderProducts.fromMap(e.data))
          .toList();
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Order Products Get of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  // create new order products
  Future createOrderProducts({
    required String orderId,
    required String productId,
    required String productName,
    required int quantity,
    required int sellingPrice,
    required int totalPrice,
  }) async {
    var id = ID.unique();

    await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.ordersProductCollectionId,
      documentId: id,
      data: {
        "order_id": orderId,
        "product_id": productId,
        "quantity": quantity,
        "product_name": productName,
        "selling_price": sellingPrice,
        "total_price": totalPrice,
      },
    );
    return true;
  }

  // update order status
  Future updateOrderStatus({
    required String id,
    required String orderStatus,
  }) async {
    try {
      await _databases.updateDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.ordersCollectionId,
        documentId: id,
        data: {
          "order_status": orderStatus,
        },
      );
      return true;
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Update order status business_id: ${storage.read("businessId")}: $e ");
    }
  }
}
