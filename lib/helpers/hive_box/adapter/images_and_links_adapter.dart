// GENERATED CODE - DO NOT MODIFY BY HAND
// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************
// old stuff to avoid hive error cannot load type adapter with id 87 (55 + 32 internal hive offset )
// not necessary if create a new db

import 'package:hive_ce/hive.dart';

import '../../../models/image_and_link.dart';

class ImageAndLinkAdapter extends TypeAdapter<ImageAndLink> {
  @override
  final int typeId = 55;

  @override
  ImageAndLink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageAndLink(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ImageAndLink obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.link)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageAndLinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
