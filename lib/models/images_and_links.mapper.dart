// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'images_and_links.dart';

class ImageAndLinkListMapper extends ClassMapperBase<ImageAndLinkList> {
  ImageAndLinkListMapper._();

  static ImageAndLinkListMapper? _instance;
  static ImageAndLinkListMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ImageAndLinkListMapper._());
      ImageAndLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'ImageAndLinkList';

  static List<ImageAndLink>? _$imagesAndLinks(ImageAndLinkList v) =>
      v.imagesAndLinks;
  static const Field<ImageAndLinkList, List<ImageAndLink>> _f$imagesAndLinks =
      Field('imagesAndLinks', _$imagesAndLinks, key: 'ial');
  static Exception? _$rpcException(ImageAndLinkList v) => v.rpcException;
  static const Field<ImageAndLinkList, Exception> _f$rpcException =
      Field('rpcException', _$rpcException, opt: true);

  @override
  final Map<Symbol, Field<ImageAndLinkList, dynamic>> fields = const {
    #imagesAndLinks: _f$imagesAndLinks,
    #rpcException: _f$rpcException,
  };

  static ImageAndLinkList _instantiate(DecodingData data) {
    return ImageAndLinkList(
        data.dec(_f$imagesAndLinks), data.dec(_f$rpcException));
  }

  @override
  final Function instantiate = _instantiate;

  static ImageAndLinkList fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<ImageAndLinkList>(map));
  }

  static ImageAndLinkList fromJson(String json) {
    return _guard((c) => c.fromJson<ImageAndLinkList>(json));
  }
}

mixin ImageAndLinkListMappable {
  String toJson() {
    return ImageAndLinkListMapper._guard(
        (c) => c.toJson(this as ImageAndLinkList));
  }

  Map<String, dynamic> toMap() {
    return ImageAndLinkListMapper._guard(
        (c) => c.toMap(this as ImageAndLinkList));
  }

  ImageAndLinkListCopyWith<ImageAndLinkList, ImageAndLinkList, ImageAndLinkList>
      get copyWith => _ImageAndLinkListCopyWithImpl(
          this as ImageAndLinkList, $identity, $identity);
  @override
  String toString() {
    return ImageAndLinkListMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            ImageAndLinkListMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return ImageAndLinkListMapper._guard((c) => c.hash(this));
  }
}

extension ImageAndLinkListValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ImageAndLinkList, $Out> {
  ImageAndLinkListCopyWith<$R, ImageAndLinkList, $Out>
      get $asImageAndLinkList =>
          $base.as((v, t, t2) => _ImageAndLinkListCopyWithImpl(v, t, t2));
}

abstract class ImageAndLinkListCopyWith<$R, $In extends ImageAndLinkList, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, ImageAndLink,
      ImageAndLinkCopyWith<$R, ImageAndLink, ImageAndLink>>? get imagesAndLinks;
  $R call({List<ImageAndLink>? imagesAndLinks, Exception? rpcException});
  ImageAndLinkListCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ImageAndLinkListCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ImageAndLinkList, $Out>
    implements ImageAndLinkListCopyWith<$R, ImageAndLinkList, $Out> {
  _ImageAndLinkListCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ImageAndLinkList> $mapper =
      ImageAndLinkListMapper.ensureInitialized();
  @override
  ListCopyWith<$R, ImageAndLink,
          ImageAndLinkCopyWith<$R, ImageAndLink, ImageAndLink>>?
      get imagesAndLinks => $value.imagesAndLinks != null
          ? ListCopyWith($value.imagesAndLinks!, (v, t) => v.copyWith.$chain(t),
              (v) => call(imagesAndLinks: v))
          : null;
  @override
  $R call({Object? imagesAndLinks = $none, Object? rpcException = $none}) =>
      $apply(FieldCopyWithData({
        if (imagesAndLinks != $none) #imagesAndLinks: imagesAndLinks,
        if (rpcException != $none) #rpcException: rpcException
      }));
  @override
  ImageAndLinkList $make(CopyWithData data) => ImageAndLinkList(
      data.get(#imagesAndLinks, or: $value.imagesAndLinks),
      data.get(#rpcException, or: $value.rpcException));

  @override
  ImageAndLinkListCopyWith<$R2, ImageAndLinkList, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ImageAndLinkListCopyWithImpl($value, $cast, t);
}
