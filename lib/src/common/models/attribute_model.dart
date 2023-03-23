import 'collection_model.dart';

class Attribute {
  final String fieldName;
  final String fieldDataType;
  final Collection collection;
  final bool isRequired;
  final bool isUnique;

  Attribute({
    required this.fieldName,
    required this.fieldDataType,
    required this.collection,
    this.isRequired = true,
    this.isUnique = false,
  });
  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        fieldName: json["fieldName"],
        fieldDataType: json["fieldDataType"],
        collection: Collection.fromJson(json["collection"]),
        isRequired: json["isRequired"],
        isUnique: json["isUnique"],
      );
  Map<String, dynamic> toJson() => {
        "fieldName": fieldName,
        "fieldDataType": fieldDataType,
        "collection": collection.toJson(),
        "isRequired": isRequired,
        "isUnique": isUnique,
      };
}
