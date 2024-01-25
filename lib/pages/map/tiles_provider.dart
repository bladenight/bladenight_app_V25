
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';


class CachedAssetProvider extends TileProvider {
  CachedAssetProvider(
      {required BuildContext context, required Null Function() errorListener});

  @override
  ImageProvider getImage(coordinates, TileLayer options) {
    return AssetImage(getTileUrl(coordinates, options));
  }
}