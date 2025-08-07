import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';

class BnCachedAssetProvider extends TileProvider {
  BnCachedAssetProvider(
      {required BuildContext context,
      required Null Function() errorListener,
      required ErrorTileCallBack callBack});

  @override
  ImageProvider getImage(coordinates, TileLayer options) {
    return AssetImage(getTileUrl(coordinates, options));
  }
}
