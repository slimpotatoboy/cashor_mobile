import 'dart:convert';

class People {
  People({
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.type,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  String name;
  dynamic phone;
  dynamic email;
  dynamic address;
  dynamic type;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions;

  factory People.fromJson(String str) => People.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory People.fromMap(Map<String, dynamic> json) => People(
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        type: json["type"],
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
      "type": type,
    };

    return map;
  }
}
