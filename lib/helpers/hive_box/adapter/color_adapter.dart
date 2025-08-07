import 'package:flutter/cupertino.dart';
import 'package:hive_ce/hive.dart';

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 221;

  @override
  Color read(BinaryReader reader) => Color(reader.readUint32());

  @override
  void write(BinaryWriter writer, Color obj) =>
      writer.writeUint32(obj.toARGB32());
}
