import 'package:hive/hive.dart';
import 'package:node_server_maker/src/common/enums/enums.dart';
part 'server_auth_model.g.dart';

@HiveType(typeId: 3)
class ServerAuthentication extends HiveObject {
  @HiveField(0)
  String? userName;
  @HiveField(1)
  String? password;
  @HiveField(2)
  String? token;
  @HiveField(3)
  AuthenticationLevel? authenticationLevel;
  ServerAuthentication(
      {required this.authenticationLevel,
      required this.password,
      required this.token,
      required this.userName});
  ServerAuthentication.basic({
    required String userName,
    required String password,
  }) : this(
            userName: userName,
            password: password,
            token: null,
            authenticationLevel: AuthenticationLevel.BASIC);
  ServerAuthentication.none()
      : this(
          userName: null,
          password: null,
          token: null,
          authenticationLevel: AuthenticationLevel.NONE,
        );
  ServerAuthentication.token({
    required String token,
  }) : this(
            userName: null,
            password: null,
            token: token,
            authenticationLevel: AuthenticationLevel.TOKEN);
}
