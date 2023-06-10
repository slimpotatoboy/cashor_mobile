import 'dart:convert';

class Books {
  Books({
    required this.businessId,
    this.bookName,
    this.bookNetBalance,
    this.totalCashIn,
    this.totalCashOut,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  String businessId;
  dynamic bookName;
  dynamic bookNetBalance;
  dynamic totalCashIn;
  dynamic totalCashOut;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions;

  factory Books.fromJson(String str) => Books.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Books.fromMap(Map<String, dynamic> json) => Books(
        businessId: json["business_id"],
        bookName: json["book_name"],
        bookNetBalance: json["book_net_balance"],
        totalCashIn: json["total_cash_in"],
        totalCashOut: json["total_cash_out"],
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "businessId": businessId,
      "bookName": bookName,
      "bookNetBalance": bookNetBalance,
      "totalCashIn": totalCashIn,
      "totalCashOut": totalCashOut,
    };

    return map;
  }
}
