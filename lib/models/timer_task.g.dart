// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerTaskAdapter extends TypeAdapter<TimerTask> {
  @override
  final int typeId = 4;

  @override
  TimerTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerTask(
      boxName: fields[0] as String,
      projectKey: fields[1] as int,
      task: fields[2] as Task,
    );
  }

  @override
  void write(BinaryWriter writer, TimerTask obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.boxName)
      ..writeByte(1)
      ..write(obj.projectKey)
      ..writeByte(2)
      ..write(obj.task);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
