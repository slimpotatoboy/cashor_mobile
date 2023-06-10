import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/config/logger.dart';
import 'package:cashor_app/models/cart_model.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/config/constants.dart' as constants;
import 'package:cashor_app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

class CartService {
  final Databases _databases = Databases(Appwrite.instance.client);
  final authService = AuthService();
  final storage = GetStorage();

  Future create({
    required String productId,
    required String productName,
    required int quantity,
    required int price,
    required int totalPrice,
  }) async {
    var id = ID.unique();
    await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.cartCollectionId,
      documentId: id,
      data: {
        "business_id": storage.read('businessId'),
        "product_id": productId,
        "product_name": productName,
        "quantity": quantity,
        "price": price,
        "total_price": totalPrice,
      },
    );
    return true;
  }

  Future fetch() async {
    try {
      final cartList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.cartCollectionId,
        queries: [
          Query.equal(
            "business_id",
            storage.read("businessId"),
          ),
          Query.orderDesc("\$id")
        ],
      );
      return cartList.documents.map((e) => Carts.fromMap(e.data)).toList();
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Cart Fetch all of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  Future udpate({
    required String id,
    required int quantity,
    required int totalPrice,
  }) async {
    try {
      await _databases.updateDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.cartCollectionId,
        documentId: id,
        data: {
          "quantity": quantity,
          "total_price": totalPrice,
        },
      );
      return true;
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Cart Update of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  Future delete(String id) async {
    try {
      await _databases.deleteDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.cartCollectionId,
        documentId: id,
      );
      return true;
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Delete Cart of business_id: ${storage.read("businessId")}: $e ");
    }
  }
}
