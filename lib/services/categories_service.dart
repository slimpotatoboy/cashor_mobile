import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/config/logger.dart';
import 'package:cashor_app/models/categories_model.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/config/constants.dart' as constants;
import 'package:cashor_app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

class CategoriesService {
  final Databases _databases = Databases(Appwrite.instance.client);
  final authService = AuthService();
  final storage = GetStorage();

  // fetch all the categories
  Future fetch() async {
    try {
      final categoriesList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.categoriesCollectionId,
        queries: [Query.orderDesc("\$id")],
      );
      return categoriesList.documents
          .map((e) => Categories.fromMap(e.data))
          .toList();
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Category Fetch all of business_id: ${storage.read("businessId")}: $e ");
    }
  }
}
