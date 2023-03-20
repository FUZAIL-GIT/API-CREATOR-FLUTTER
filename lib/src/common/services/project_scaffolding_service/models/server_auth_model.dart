import 'package:node_server_maker/src/common/enums/enums.dart';

class ServerAuthentication {
  String? userName;
  String? password;
  String? token;
  AuthenticationLevel? authenticationLevel;
  ServerAuthentication(
      {required this.authenticationLevel,
      required this.password,
      required this.token,
      required this.userName});
  ServerAuthentication.basic({
    required AuthenticationLevel authenticationLevel,
    required String userName,
    required String password,
  }) : this(
            userName: userName,
            password: password,
            token: null,
            authenticationLevel: AuthenticationLevel.BASIC);
  ServerAuthentication.none({
    required AuthenticationLevel authenticationLevel,
  }) : this(
          userName: null,
          password: null,
          token: null,
          authenticationLevel: AuthenticationLevel.NONE,
        );
  ServerAuthentication.token({
    required AuthenticationLevel authenticationLevel,
    required String token,
  }) : this(
            userName: null,
            password: null,
            token: token,
            authenticationLevel: AuthenticationLevel.TOKEN);
}
