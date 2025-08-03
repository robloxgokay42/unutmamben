// lib/main.g.dart
// Bu dosya 'main.dart' içindeki 'Reminder' modelinin adaptörünü içerir.
// GitHub'da 'lib' klasörünün içine bu dosyayı oluşturup aşağıdaki içeriği yapıştırın.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderTypeAdapter extends TypeAdapter<ReminderType> {
  @override
  final int typeId = 0;

  @override
  ReminderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderType.text;
      case 1:
        return ReminderType.voice;
      case 2:
        return ReminderType.emoji;
      default:
        return ReminderType.text;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderType obj) {
    switch (obj) {
      case ReminderType.text:
        writer.writeByte(0);
        break;
      case ReminderType.voice:
        writer.writeByte(1);
        break;
      case ReminderType.emoji:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 1;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      id: fields[0] as String,
      type: fields[1] as ReminderType,
      content: fields[2] as String,
      reminderTime: fields[3] as DateTime,
      isDone: fields[4] as bool,
      isRepeating: fields[5] as bool,
      voiceNotePath: fields[6] as String?,
      isVoiced: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.reminderTime)
      ..writeByte(4)
      ..write(obj.isDone)
      ..writeByte(5)
      ..write(obj.isRepeating)
      ..writeByte(6)
      ..write(obj.voiceNotePath)
      ..writeByte(7)
      ..write(obj.isVoiced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
