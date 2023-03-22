import 'package:hive/hive.dart';
part 'collection_model.g.dart';

@HiveType(typeId: 1)
class Collection extends HiveObject {
  @HiveField(0)
  final String collectionName;
  @HiveField(1)
  bool isTimeStamp;
  @HiveField(2)
  bool isPagination;
  Collection({
    required this.collectionName,
    required this.isTimeStamp,
    required this.isPagination,
  });
}
