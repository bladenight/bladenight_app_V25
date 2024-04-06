import 'package:dart_mappable/dart_mappable.dart';
import 'package:hive/hive.dart';

part 'image_and_link.mapper.dart';
part 'image_and_link.g.dart';


@HiveType(typeId: 55)
@MappableClass()
class ImageAndLink with ImageAndLinkMappable {
  @HiveField(0)
  @MappableField(key: 'img')
  final String? image;
  @HiveField(1)
  @MappableField(key: 'lnk')
  final String? link;
  @HiveField(2)
  @MappableField(key: 'txt')
  final String? text;
  @HiveField(3)
  @MappableField(key: 'key')
  final String? key;

  ImageAndLink(this.image, this.link, this.text, this.key);
}
