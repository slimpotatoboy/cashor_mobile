import 'dart:convert';

class Orders {
  Orders({
    this.paymentMethod,
    this.note,
    this.businessId,
    this.customerId,
    this.orderStatus,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  dynamic paymentMethod;
  dynamic note;
  dynamic businessId;
  dynamic customerId;
  dynamic orderStatus;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions;

  factory Orders.fromJson(String str) => Orders.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Orders.fromMap(Map<String, dynamic> json) => Orders(
        paymentMethod: json["payment_method"],
        note: json["note"],
        businessId: json["business_id"],
        customerId: json["customer_id"],
        orderStatus: json["order_status"].toString().toLowerCase(),
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "paymentMethod": paymentMethod,
      "note": note,
      "businessId": businessId,
      "customerId": customerId,
      "orderStatus": orderStatus,
    };

    return map;
  }
}
