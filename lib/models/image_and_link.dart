import 'package:dart_mappable/dart_mappable.dart';

part 'image_and_link.mapper.dart';

@MappableClass()
class ImageAndLink with ImageAndLinkMappable {
  @MappableField(key: 'img')
  final String? image;
  @MappableField(key: 'lnk')
  final String? link;
  @MappableField(key: 'txt')
  final String? text;
  @MappableField(key: 'key')
  final String? key;

  ImageAndLink(this.image, this.link, this.text, this.key);
}
