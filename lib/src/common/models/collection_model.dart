class Collection {
  int? id;
  final String collectionName;
  bool isTimeStamp;
  bool isPagination;
  Collection({
    required this.collectionName,
    required this.isTimeStamp,
    required this.isPagination,
  });
  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        collectionName: json["collectionName"],
        isTimeStamp: json["isTimeStamp"],
        isPagination: json["isPagination"],
      );
  Map<String, dynamic> toJson() => {
        "collectionName": collectionName,
        "isTimeStamp": isTimeStamp,
        "isPagination": isPagination,
      };
}
