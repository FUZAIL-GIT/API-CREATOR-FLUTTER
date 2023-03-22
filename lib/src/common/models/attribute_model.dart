import 'package:hive/hive.dart';
import 'collection_model.dart';
part 'attribute_model.g.dart';

@HiveType(typeId: 0)
class Attribute extends HiveObject {
  @HiveField(0)
  final String fieldName;
  @HiveField(1)
  final String fieldDataType;
  @HiveField(2)
  final Collection collection;
  @HiveField(3)
  final bool isRequired;
  @HiveField(4)
  final bool isUnique;

  Attribute({
    required this.fieldName,
    required this.fieldDataType,
    required this.collection,
    this.isRequired = true,
    this.isUnique = false,
  });
}
