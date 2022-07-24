// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_timer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroTimerAdapter extends TypeAdapter<PomodoroTimer> {
  @override
  final int typeId = 3;

  @override
  PomodoroTimer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroTimer(
      workTime: fields[0] as int,
      shortBreakTime: fields[1] as int,
      longBreakTime: fields[2] as int,
      longInterval: fields[3] as int,
      workCycle: fields[4] as int,
      notify: fields[5] as bool,
      autoStart: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroTimer obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.workTime)
      ..writeByte(1)
      ..write(obj.shortBreakTime)
      ..writeByte(2)
      ..write(obj.longBreakTime)
      ..writeByte(3)
      ..write(obj.longInterval)
      ..writeByte(4)
      ..write(obj.workCycle)
      ..writeByte(5)
      ..write(obj.notify)
      ..writeByte(6)
      ..write(obj.autoStart);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroTimerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
