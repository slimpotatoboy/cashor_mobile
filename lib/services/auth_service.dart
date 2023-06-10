import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService {
  final Account _account = Account(Appwrite.instance.client);
  final storage = GetStorage();

  // user signup
  Future signUp(
      {String? name, required String email, required String password}) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return login(email: email, password: password);
    } on AppwriteException catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: "${e.code}",
          message: '${e.response['message']}',
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // user login
  Future login({required String email, required String password}) async {
    try {
      await _account.createEmailSession(
        email: email,
        password: password,
      );
      final session = await _account.get();
      storage.write('userId', session.$id);
      return session;
    } on AppwriteException catch (e) {
      // exception
      Get.showSnackbar(
        GetSnackBar(
          title: "${e.code}",
          message: '${e.response['message']}',
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // user logout
  Future<void> logout() {
    return _account.deleteSession(sessionId: 'current');
  }

  // get the user id
  Future getAccountId() async {
    final session = await _account.get();
    return session.$id;
  }

  // get user details
  Future getUser() async {
    final session = await _account.get();
    return session;
  }

  // when user updates their username
  Future updateName(String name) async {
    final result = await _account.updateName(name: name);
    return result;
  }

  // update password
  Future updatePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      final result = await _account.updatePassword(
        oldPassword: oldPassword,
        password: newPassword,
      );
      return result;
    } on AppwriteException catch (e) {
      return e;
    }
  }
}
