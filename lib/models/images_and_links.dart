import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_settings/app_constants.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/wamp/message_types.dart';
import '../providers/get_images_and_links_provider.dart';
import '../wamp/bn_wamp_message.dart';
import '../wamp/wamp_endpoints.dart';
import '../wamp/wamp_exception.dart';
import '../wamp/wamp_v2.dart';
import 'image_and_link.dart';

export 'package:latlong2/latlong.dart';

part 'images_and_links.mapper.dart';

@MappableClass()
class ImageAndLinkList with ImageAndLinkListMappable {
  @MappableField(key: 'ial')
  final List<ImageAndLink>? imagesAndLinks;

  Exception? rpcException;

  ImageAndLinkList(this.imagesAndLinks, [this.rpcException]);

  static ImageAndLinkList rpcError(Exception exception) {
    return ImageAndLinkList(null, exception);
  }

  static Future<ImageAndLinkList> getImagesAndLinks() async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.getImagesAndLinks);
    var wampResult = await WampV2()
        .addToWamp<ImageAndLinkList>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => error);
    if (wampResult is Map<String, dynamic>) {
      var ialList =
          MapperContainer.globals.fromMap<ImageAndLinkList>(wampResult);
      HiveSettingsDB.setImagesAndLinksJson(ialList.toJson());
      return ialList;
    }
    if (wampResult is ImageAndLinkList) {
      if (HiveSettingsDB.imagesAndLinksJson.isNotEmpty) {
        return MapperContainer.globals
            .fromJson<ImageAndLinkList>(HiveSettingsDB.imagesAndLinksJson);
      }
      return wampResult;
    }
    if (wampResult is WampException) {
      return ImageAndLinkList.rpcError(wampResult);
    }
    if (wampResult is TimeoutException) {
      return ImageAndLinkList.rpcError(wampResult);
    }
    return ImageAndLinkList.rpcError(
        WampException(WampExceptionReason.unknown));
  }

  @override
  String toString() {
    return 'ImagesAndLinks - length:${imagesAndLinks?.length}';
  }
}
