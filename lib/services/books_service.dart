import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/config/logger.dart';
import 'package:cashor_app/models/books_model.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/config/constants.dart' as constants;
import 'package:cashor_app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

// related to books database

class BooksService {
  final Databases _databases = Databases(Appwrite.instance.client);
  final authService = AuthService();
  final storage = GetStorage();

  // create new book
  Future create({required String bookName}) async {
    var id = ID.unique();
    await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.booksCollectionId,
      documentId: id,
      data: {
        "user_id": await authService.getAccountId(),
        "business_id": storage.read('businessId'),
        "book_name": bookName,
        "book_net_balance": 0,
        "total_cash_in": 0,
        "total_cash_out": 0,
      },
    );
    return true;
  }

  // fetch all the books
  Future fetch() async {
    final userId = await authService.getAccountId();
    try {
      final booksList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.booksCollectionId,
        queries: [
          Query.equal(
            "user_id",
            userId,
          ),
          Query.equal(
            "business_id",
            storage.read("businessId"),
          ),
          Query.orderDesc("\$id")
        ],
      );
      return booksList.documents.map((e) => Books.fromMap(e.data)).toList();
    } on AppwriteException catch (e) {
      DiscordLog().log("Book Fetch all of user_id: $userId: $e ");
    }
  }

  // update single book
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
      DiscordLog().log("Book Update of $id: $e ");
    }
  }

  // fetch single book
  Future get(String id) async {
    final userId = await authService.getAccountId();
    try {
      final booksList = await _databases.getDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.booksCollectionId,
        documentId: id,
        queries: [
          Query.equal("user_id", userId),
        ],
      );
      return Books.fromMap(booksList.data);
    } on AppwriteException catch (e) {
      DiscordLog().log("Single Book Page of Id:$userId: $e ");
    }
  }
}
