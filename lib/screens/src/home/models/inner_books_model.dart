import 'dart:convert';

class InnerBooks {
  InnerBooks({
    required this.booksId,
    required this.remarks,
    required this.updatedBy,
    required this.balance,
    this.cashIn,
    this.cashOut,
    this.type,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  String booksId;
  dynamic remarks;
  dynamic updatedBy;
  dynamic balance;
  dynamic cashIn;
  dynamic cashOut;
  dynamic type;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions;

  factory InnerBooks.fromJson(String str) =>
      InnerBooks.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InnerBooks.fromMap(Map<String, dynamic> json) => InnerBooks(
        booksId: json["books_id"],
        remarks: json["remarks"],
        updatedBy: json["updated_by"],
        balance: json["balance"],
        cashIn: json["cash_in"],
        cashOut: json["cash_out"],
        type: json["type"],
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "booksId": booksId,
      "remarks": remarks,
      "updatedBy": updatedBy,
      "balance": balance,
      "cashIn": cashIn,
      "cashOut": cashOut,
      "type": type,
    };

    return map;
  }
}
