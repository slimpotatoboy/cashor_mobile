import 'dart:convert';

class Businesses {
  Businesses({
    required this.name,
    this.registrationNumber,
    this.businessEmail,
    this.businessPhone,
    this.bankAccount,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  String name;
  dynamic registrationNumber;
  dynamic businessEmail;
  dynamic businessPhone;
  dynamic bankAccount;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions;

  factory Businesses.fromJson(String str) =>
      Businesses.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Businesses.fromMap(Map<String, dynamic> json) => Businesses(
        name: json["name"],
        registrationNumber: json["registration_number"],
        businessEmail: json["business_email"],
        businessPhone: json["business_phone"],
        bankAccount: json["business_bank_account_number"],
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "name": name,
      "registrationNumber": registrationNumber,
      "businessEmail": businessEmail,
      "businessPhone": businessPhone,
      "bankAccount": bankAccount,
    };

    return map;
  }
}
