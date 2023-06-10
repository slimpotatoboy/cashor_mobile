import 'dart:convert';

class Categories {
  Categories({
    required this.name,
    this.image,
    this.description,
    this.parentId,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  String name;
  dynamic image;
  dynamic description;
  dynamic parentId;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions;

  factory Categories.fromJson(String str) =>
      Categories.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Categories.fromMap(Map<String, dynamic> json) => Categories(
        name: json["name"],
        image: json["image"],
        description: json["description"],
        parentId: json["parent_id"],
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "name": name,
      "image": image,
      "description": description,
      "parentId": parentId,
    };

    return map;
  }
}
