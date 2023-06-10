import 'dart:convert';

class Products {
  Products({
    required this.name,
    this.description,
    this.thumbnail,
    this.status,
    this.supplierName,
    this.categoryName,
    this.slug,
    this.costPrice,
    this.sellingPrice,
    this.currentStock,
    this.initialStock,
    this.businessId,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  String name;
  dynamic description;
  dynamic thumbnail;
  dynamic status;
  dynamic supplierName;
  dynamic categoryName;
  dynamic slug;
  dynamic costPrice;
  dynamic sellingPrice;
  dynamic currentStock;
  dynamic initialStock;
  dynamic businessId;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions;

  factory Products.fromJson(String str) => Products.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Products.fromMap(Map<String, dynamic> json) => Products(
        name: json["name"],
        thumbnail: json["thumbnail"],
        description: json["description"],
        status: json["status"],
        supplierName: json["supplier_name"],
        categoryName: json["category_name"],
        slug: json["slug"],
        costPrice: json["cost_price"],
        sellingPrice: json["selling_price"],
        currentStock: json["current_stock"],
        initialStock: json["initial_stock"],
        businessId: json["business_id"],
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "name": name,
      "thumbnail": thumbnail,
      "description": description,
      "status": status,
      "supplierName": supplierName,
      "categoryName": categoryName,
      "slug": slug,
      "costPrice": costPrice,
      "sellingPrice": sellingPrice,
      "currentStock": currentStock,
      "initialStock": initialStock,
      "businessId": businessId,
    };

    return map;
  }
}
