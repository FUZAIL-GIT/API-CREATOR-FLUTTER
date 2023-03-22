// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServertDetailsAdapter extends TypeAdapter<ServertDetails> {
  @override
  final int typeId = 4;

  @override
  ServertDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServertDetails(
      attributes: (fields[1] as List).cast<Attribute>(),
      collections: (fields[0] as List).cast<Collection>(),
      mongoDbUrl: fields[2] as String,
      serverAuthentication: fields[3] as ServerAuthentication,
    );
  }

  @override
  void write(BinaryWriter writer, ServertDetails obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.collections)
      ..writeByte(1)
      ..write(obj.attributes)
      ..writeByte(2)
      ..write(obj.mongoDbUrl)
      ..writeByte(3)
      ..write(obj.serverAuthentication);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServertDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
