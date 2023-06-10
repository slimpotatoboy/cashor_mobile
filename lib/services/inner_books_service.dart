import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/config/logger.dart';
import 'package:cashor_app/screens/src/home/models/inner_books_model.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/config/constants.dart' as constants;
import 'package:cashor_app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

class InnerBooksService {
  final Databases _databases = Databases(Appwrite.instance.client);
  final authService = AuthService();
  final storage = GetStorage();

  Future create({
    required String booksId,
    required String remarks,
    required dynamic balance,
    dynamic cashIn,
    dynamic cashOut,
  }) async {
    var id = ID.unique();
    await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.innerBooksCollectionId,
      documentId: id,
      data: {
        "books_id": booksId,
        "remarks": remarks,
        "updated_by": await authService.getAccountId(),
        "balance": balance,
        "cash_in": cashIn,
        "cash_out": cashOut,
      },
    );
    return true;
  }

  Future fetch(booksId) async {
    try {
      final innerBooksList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.innerBooksCollectionId,
        queries: [
          Query.equal(
            "books_id",
            booksId,
          ),
          Query.orderDesc("\$id")
        ],
      );
      return innerBooksList.documents
          .map((e) => InnerBooks.fromMap(e.data))
          .toList();
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Book Fetch all of business_id: ${storage.read("businessId")}: $e ");
    }
  }
}
