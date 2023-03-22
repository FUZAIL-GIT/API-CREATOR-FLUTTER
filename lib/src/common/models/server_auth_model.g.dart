// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_auth_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerAuthenticationAdapter extends TypeAdapter<ServerAuthentication> {
  @override
  final int typeId = 3;

  @override
  ServerAuthentication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerAuthentication(
      authenticationLevel: fields[3] as AuthenticationLevel?,
      password: fields[1] as String?,
      token: fields[2] as String?,
      userName: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ServerAuthentication obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.token)
      ..writeByte(3)
      ..write(obj.authenticationLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerAuthenticationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
