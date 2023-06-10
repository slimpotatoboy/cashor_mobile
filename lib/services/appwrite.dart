import 'package:appwrite/appwrite.dart';

import '../config/constants.dart' as constants;

// Appwrite instance
class Appwrite {
  static final Appwrite instance = Appwrite._internal();
  late final Client client;

  factory Appwrite._() {
    return instance;
  }

  Appwrite._internal() {
    client = Client()
        .setEndpoint(constants.appwriteEndpoint)
        .setProject(constants.appwriteProjectId);
  }
}
