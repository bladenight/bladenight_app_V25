// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'image_and_link.dart';

class ImageAndLinkMapper extends ClassMapperBase<ImageAndLink> {
  ImageAndLinkMapper._();

  static ImageAndLinkMapper? _instance;
  static ImageAndLinkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ImageAndLinkMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ImageAndLink';

  static String? _$image(ImageAndLink v) => v.image;
  static const Field<ImageAndLink, String> _f$image =
      Field('image', _$image, key: r'img');
  static String? _$link(ImageAndLink v) => v.link;
  static const Field<ImageAndLink, String> _f$link =
      Field('link', _$link, key: r'lnk');
  static String? _$text(ImageAndLink v) => v.text;
  static const Field<ImageAndLink, String> _f$text =
      Field('text', _$text, key: r'txt');
  static String? _$key(ImageAndLink v) => v.key;
  static const Field<ImageAndLink, String> _f$key = Field('key', _$key);

  @override
  final MappableFields<ImageAndLink> fields = const {
    #image: _f$image,
    #link: _f$link,
    #text: _f$text,
    #key: _f$key,
  };

  static ImageAndLink _instantiate(DecodingData data) {
    return ImageAndLink(data.dec(_f$image), data.dec(_f$link),
        data.dec(_f$text), data.dec(_f$key));
  }

  @override
  final Function instantiate = _instantiate;

  static ImageAndLink fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ImageAndLink>(map);
  }

  static ImageAndLink fromJson(String json) {
    return ensureInitialized().decodeJson<ImageAndLink>(json);
  }
}

mixin ImageAndLinkMappable {
  String toJson() {
    return ImageAndLinkMapper.ensureInitialized()
        .encodeJson<ImageAndLink>(this as ImageAndLink);
  }

  Map<String, dynamic> toMap() {
    return ImageAndLinkMapper.ensureInitialized()
        .encodeMap<ImageAndLink>(this as ImageAndLink);
  }

  ImageAndLinkCopyWith<ImageAndLink, ImageAndLink, ImageAndLink> get copyWith =>
      _ImageAndLinkCopyWithImpl(this as ImageAndLink, $identity, $identity);
  @override
  String toString() {
    return ImageAndLinkMapper.ensureInitialized()
        .stringifyValue(this as ImageAndLink);
  }

  @override
  bool operator ==(Object other) {
    return ImageAndLinkMapper.ensureInitialized()
        .equalsValue(this as ImageAndLink, other);
  }

  @override
  int get hashCode {
    return ImageAndLinkMapper.ensureInitialized()
        .hashValue(this as ImageAndLink);
  }
}

extension ImageAndLinkValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ImageAndLink, $Out> {
  ImageAndLinkCopyWith<$R, ImageAndLink, $Out> get $asImageAndLink =>
      $base.as((v, t, t2) => _ImageAndLinkCopyWithImpl(v, t, t2));
}

abstract class ImageAndLinkCopyWith<$R, $In extends ImageAndLink, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? image, String? link, String? text, String? key});
  ImageAndLinkCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ImageAndLinkCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ImageAndLink, $Out>
    implements ImageAndLinkCopyWith<$R, ImageAndLink, $Out> {
  _ImageAndLinkCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ImageAndLink> $mapper =
      ImageAndLinkMapper.ensureInitialized();
  @override
  $R call(
          {Object? image = $none,
          Object? link = $none,
          Object? text = $none,
          Object? key = $none}) =>
      $apply(FieldCopyWithData({
        if (image != $none) #image: image,
        if (link != $none) #link: link,
        if (text != $none) #text: text,
        if (key != $none) #key: key
      }));
  @override
  ImageAndLink $make(CopyWithData data) => ImageAndLink(
      data.get(#image, or: $value.image),
      data.get(#link, or: $value.link),
      data.get(#text, or: $value.text),
      data.get(#key, or: $value.key));

  @override
  ImageAndLinkCopyWith<$R2, ImageAndLink, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ImageAndLinkCopyWithImpl($value, $cast, t);
}
