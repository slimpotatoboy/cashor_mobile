import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/config/logger.dart';
import 'package:cashor_app/models/books_model.dart';
import 'package:cashor_app/models/people_model.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/config/constants.dart' as constants;
import 'package:cashor_app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

class PeopleServices {
  final Databases _databases = Databases(Appwrite.instance.client);
  final authService = AuthService();
  final storage = GetStorage();

  Future create({
    required String name,
    required String phone,
    required String email,
    required String address,
    required String type,
  }) async {
    var id = ID.unique();
    await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.peopleCollectionId,
      documentId: id,
      data: {
        "user_id": await authService.getAccountId(),
        "business_id": storage.read('businessId'),
        "name": name,
        "phone": phone,
        "email": email,
        "address": address,
        "type": type,
      },
    );
    return true;
  }

  Future fetch({String? type}) async {
    try {
      final peopleList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.peopleCollectionId,
        queries: [
          Query.equal(
            "user_id",
            await authService.getAccountId(),
          ),
          Query.equal(
            "business_id",
            storage.read("businessId"),
          ),
          Query.orderDesc("\$id"),
          if (type != null)
            Query.equal(
              "type",
              type,
            ),
        ],
      );
      return peopleList.documents.map((e) => People.fromMap(e.data)).toList();
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Customer Fetch of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  Future udpate(
      {required String id,
      required dynamic bookNetBalance,
      required dynamic totalCashIn,
      required dynamic totalCashOut}) async {
    try {
      await _databases.updateDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.booksCollectionId,
        documentId: id,
        data: {
          "book_net_balance": bookNetBalance,
          "total_cash_in": totalCashIn,
          "total_cash_out": totalCashOut,
        },
      );
      return true;
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Customer Update of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  Future get(String id) async {
    try {
      final booksList = await _databases.getDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.booksCollectionId,
        documentId: id,
        queries: [
          Query.equal(
            "user_id",
            await authService.getAccountId(),
          ),
        ],
      );
      return Books.fromMap(booksList.data);
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Customer get single of business_id: ${storage.read("businessId")}: $e ");
    }
  }
}
