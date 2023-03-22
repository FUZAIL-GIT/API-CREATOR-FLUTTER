import 'package:hive/hive.dart';
import 'package:node_server_maker/src/common/models/server_auth_model.dart';
import 'package:node_server_maker/src/common/models/collection_model.dart';
import 'attribute_model.dart';
part 'server_details_model.g.dart';

@HiveType(typeId: 4)
class ServertDetails extends HiveObject {
  @HiveField(0)
  List<Collection> collections;
  @HiveField(1)
  List<Attribute> attributes;
  @HiveField(2)
  String mongoDbUrl;
  @HiveField(3)
  ServerAuthentication serverAuthentication;
  ServertDetails({
    required this.attributes,
    required this.collections,
    required this.mongoDbUrl,
    required this.serverAuthentication,
  });
}
