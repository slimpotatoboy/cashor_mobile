import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/config/logger.dart';
import 'package:cashor_app/models/products_model.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/config/constants.dart' as constants;
import 'package:cashor_app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

class ProductsService {
  final Databases _databases = Databases(Appwrite.instance.client);
  final authService = AuthService();
  final storage = GetStorage();
  final appwriteStorage = Storage(Appwrite.instance.client);

  // store image of products
  Future storeImage(fileName, status) async {
    final file = await appwriteStorage.createFile(
      bucketId: constants.productFileStorageId,
      fileId: ID.unique(),
      file: InputFile.fromPath(
        path: fileName,
      ),
      permissions: [
        Permission.read(Role.any()),
      ],
    );

    return file.$id;
  }

  //delete single image
  Future deleteImage(fileId) async {
    await appwriteStorage.deleteFile(
      bucketId: constants.productFileStorageId,
      fileId: fileId,
    );

    return true;
  }

  // create new product
  Future create({
    required String name,
    String? description,
    required String thumbnail,
    required bool status,
    required String supplierId,
    required String supplierName,
    required String categoryId,
    required String categoryName,
    required String costPrice,
    required String sellingPrice,
    required String initialStock,
    required String currentStock,
  }) async {
    try {
      var id = ID.unique();
      await _databases.createDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.productCollectionId,
        documentId: id,
        data: {
          "user_id": await authService.getAccountId(),
          "business_id": storage.read('businessId'),
          "category_id": categoryId,
          "category_name": categoryName,
          "name": name,
          "description": description,
          "thumbnail": thumbnail,
          "status": status,
          "suppliers_id": supplierId,
          "supplier_name": supplierName,
          "slug": name.replaceAll(" ", "-").toLowerCase(),
          "cost_price": double.parse(costPrice),
          "selling_price": double.parse(sellingPrice),
          "initial_stock": int.parse(initialStock),
          "current_stock": int.parse(currentStock),
        },
        permissions: [
          if (status) Permission.read(Role.any()),
        ],
      );
      return true;
    } catch (e) {
      DiscordLog().log(
          "Create Product of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  // fetch products
  Future fetch() async {
    try {
      final productsList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.productCollectionId,
        queries: [
          Query.equal(
            "user_id",
            await authService.getAccountId(),
          ),
          Query.equal(
            "business_id",
            storage.read("businessId"),
          ),
          Query.orderDesc("\$id")
        ],
      );
      return productsList.documents
          .map((e) => Products.fromMap(e.data))
          .toList();
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Products Fetch of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  // update products
  Future udpate({
    required String id,
    required String name,
    String? description,
    required String thumbnail,
    required bool status,
    required String costPrice,
    required String sellingPrice,
    required String initialStock,
    required String currentStock,
  }) async {
    try {
      await _databases.updateDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.productCollectionId,
        documentId: id,
        data: {
          "name": name,
          "description": description,
          "thumbnail": thumbnail,
          "status": status,
          "cost_price": double.parse(costPrice),
          "selling_price": double.parse(sellingPrice),
          "initial_stock": int.parse(initialStock),
          "current_stock": int.parse(currentStock),
        },
        permissions: [
          if (status) Permission.read(Role.any()),
        ],
      );
      return true;
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Update Products of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  // get single product
  Future get(String id) async {
    try {
      final productsList = await _databases.getDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.productCollectionId,
        documentId: id,
        queries: [
          Query.equal(
            "user_id",
            await authService.getAccountId(),
          ),
          Query.equal(
            "business_id",
            storage.read("businessId"),
          ),
        ],
      );
      return Products.fromMap(productsList.data);
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Products Single Fetch of business_id: ${storage.read("businessId")}: $e ");
    }
  }
}
