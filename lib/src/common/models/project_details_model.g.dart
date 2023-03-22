// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectDetailsAdapter extends TypeAdapter<ProjectDetails> {
  @override
  final int typeId = 2;

  @override
  ProjectDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectDetails(
      ceratedAt: fields[1] as DateTime,
      updatedAt: (fields[2] as List).cast<DateTime>(),
      projectName: fields[0] as String,
      servertDetails: fields[3] as ServertDetails,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectDetails obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.projectName)
      ..writeByte(1)
      ..write(obj.ceratedAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.servertDetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
