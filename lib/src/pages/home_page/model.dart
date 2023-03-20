class Field {
  final String fieldName;
  final String fieldDataType;
  final Collection collection;
  final bool isRequired;
  final bool isUnique;

  Field({
    required this.fieldName,
    required this.fieldDataType,
    required this.collection,
    this.isRequired = true,
    this.isUnique = false,
  });
}

class Collection {
  final String collectionName;
  bool isTimeStamp;
  bool isPagination;
  Collection({
    required this.collectionName,
    required this.isTimeStamp,
    required this.isPagination,
  });
}
