import 'dart:convert';

class OrderProducts {
  OrderProducts({
    this.orderId,
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

  dynamic orderId;
  dynamic productId;
  dynamic quantity;
  dynamic sellingPrice;
  dynamic productName;
  dynamic totalPrice;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions;

  factory OrderProducts.fromJson(String str) =>
      OrderProducts.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderProducts.fromMap(Map<String, dynamic> json) => OrderProducts(
        orderId: json["order_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        sellingPrice: json["selling_price"],
        productName: json["product_name"],
        totalPrice: json["total_price"],
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "orderId": orderId,
      "productId": productId,
      "quantity": quantity,
      "sellingPrice": sellingPrice,
      "productName": productName,
      "totalPrice": totalPrice,
    };

    return map;
  }
}
