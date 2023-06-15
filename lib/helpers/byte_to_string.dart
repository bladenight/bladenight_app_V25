import 'dart:typed_data';

String getStringFromBytes(ByteData data) {
  final buffer = data.buffer
      .asUint8List()
      .map((e) => e.toRadixString(16).padLeft(2, '0'))
      .join();
  print(buffer);
  //var list = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  return buffer; //utf8.decode(list);
}
