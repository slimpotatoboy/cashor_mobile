import 'package:cashor_app/services/books_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final booksService = BooksService();
  List books = [];

  Future getBooks() async {
    final result = await booksService.fetch();
    if (result != null) {
      books = result;
      update();
      return books;
    }
  }
}
