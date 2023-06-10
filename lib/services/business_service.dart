import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/config/logger.dart';
import 'package:cashor_app/models/business_model.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/config/constants.dart' as constants;
import 'package:cashor_app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

class BusinessService {
  final Databases _databases = Databases(Appwrite.instance.client);
  final authService = AuthService();
  final storage = GetStorage();

  // create a new business
  Future create({
    required String name,
    required String registrationNumber,
    required String businessEmail,
    required String businessPhone,
    required String bankAccount,
  }) async {
    var id = ID.unique();
    await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.businessCollectionId,
      documentId: id,
      data: {
        "user_id": await authService.getAccountId(),
        "name": name,
        "registration_number": registrationNumber,
        "business_email": businessEmail,
        "business_phone": businessPhone,
        "business_bank_account_number": bankAccount,
      },
    );
    storage.write('businessId', id);
    return true;
  }

  // fetch all the business related to specific user
  Future fetch() async {
    final userId = await authService.getAccountId();
    try {
      final businessList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.businessCollectionId,
        queries: [
          Query.equal(
            "user_id",
            userId,
          ),
        ],
      );
      return businessList.documents
          .map((e) => Businesses.fromMap(e.data))
          .toList();
    } on AppwriteException catch (e) {
      DiscordLog().log("Business Fetch all of user_id: $userId: $e ");
    }
  }

  // update permisson of the current business
  Future updatePermission({required bool status}) async {
    await _databases.updateDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.businessCollectionId,
        documentId: storage.read("businessId"),
        permissions: [
          if (status) Permission.read(Role.any()),
        ]);
    return true;
  }

  // /get current business details
  Future get() async {
    try {
      final businessList = await _databases.getDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.businessCollectionId,
        documentId: storage.read("businessId"),
      );
      return Businesses.fromMap(businessList.data);
    } on AppwriteException catch (e) {
      DiscordLog().log(
          "Business Single Fetch all of business_id: ${storage.read("businessId")}: $e ");
    }
  }

  // update current business details
  Future update({
    required String name,
    required String registrationNumber,
    required String businessEmail,
    required String businessPhone,
    required String bankAccount,
  }) async {
    await _databases.updateDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.businessCollectionId,
      documentId: storage.read("businessId"),
      data: {
        "name": name,
        "registration_number": registrationNumber,
        "business_email": businessEmail,
        "business_phone": businessPhone,
        "business_bank_account_number": bankAccount,
      },
    );
    return true;
  }
}
