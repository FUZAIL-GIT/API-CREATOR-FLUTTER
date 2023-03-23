import 'package:node_server_maker/src/common/models/server_auth_model.dart';
import 'package:node_server_maker/src/common/models/collection_model.dart';
import 'attribute_model.dart';

class ServerDetails {
  List<Collection> collections;
  List<Attribute> attributes;
  String mongoDbUrl;
  ServerAuthentication serverAuthentication;
  ServerDetails({
    required this.attributes,
    required this.collections,
    required this.mongoDbUrl,
    required this.serverAuthentication,
  });
  factory ServerDetails.fromJson(Map<String, dynamic> json) => ServerDetails(
        attributes: List<Attribute>.from(
            json["attributes"].map((x) => Attribute.fromJson(x))),
        collections: List<Collection>.from(
            json["collections"].map((x) => Collection.fromJson(x))),
        mongoDbUrl: json["mongoDbUrl"],
        serverAuthentication:
            ServerAuthentication.fromJson(json["serverAuthentication"]),
      );
  Map<String, dynamic> toJson() => {
        "attributes": List.from(attributes.map((x) => x.toJson())),
        "collections": List.from(collections.map((x) => x.toJson())),
        "mongoDbUrl": mongoDbUrl,
        "serverAuthentication": serverAuthentication.toJson(),
      };
}
