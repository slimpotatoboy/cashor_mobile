import 'dart:convert';

class Carts {
  Carts({
    this.businessId,
    this.productId,
    this.quantity,
    this.sellingPrice,
    this.productName,
    this.totalPrice,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  dynamic businessId;
  dynamic productId;
  dynamic quantity;
  dynamic sellingPrice;
  dynamic productName;
  dynamic totalPrice;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions;

  factory Carts.fromJson(String str) => Carts.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Carts.fromMap(Map<String, dynamic> json) => Carts(
        businessId: json["business_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        sellingPrice: json["price"],
        productName: json["product_name"],
        totalPrice: json["total_price"],
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "businessId": businessId,
      "productId": productId,
      "quantity": quantity,
      "sellingPrice": sellingPrice,
      "productName": productName,
      "totalPrice": totalPrice,
    };

    return map;
  }
}
