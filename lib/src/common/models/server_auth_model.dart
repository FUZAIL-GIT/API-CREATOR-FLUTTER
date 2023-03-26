import 'package:api_creator/src/common/enums/enums.dart';

class ServerAuthentication {
  String? userName;
  String? password;
  String? token;
  late String authenticationLevel;
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
            authenticationLevel: AuthenticationLevel.BASIC.name);
  ServerAuthentication.none()
      : this(
          userName: null,
          password: null,
          token: null,
          authenticationLevel: AuthenticationLevel.NONE.name,
        );
  ServerAuthentication.token({
    required String token,
  }) : this(
            userName: null,
            password: null,
            token: token,
            authenticationLevel: AuthenticationLevel.TOKEN.name);
  factory ServerAuthentication.fromJson(Map<String, dynamic> json) =>
      ServerAuthentication(
        userName: json["userName"],
        password: json["password"],
        token: json["token"],
        authenticationLevel: json["authenticationLevel"].toString(),
      );
  Map<String, dynamic> toJson() => {
        "userName": userName,
        "password": password,
        "token": token,
        "authenticationLevel": authenticationLevel.toString(),
      };
}
