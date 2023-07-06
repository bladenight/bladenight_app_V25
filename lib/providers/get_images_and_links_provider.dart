import 'dart:convert';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_settings/app_configuration_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../models/image_and_link.dart';
import '../models/images_and_links.dart';
import 'images_and_links/bladeguard_link_image_and_link_provider.dart';
import 'images_and_links/main_sponsor_image_and_link_provider.dart';
import 'images_and_links/second_sponsor_image_and_link_provider.dart';
import 'images_and_links/startpoint_image_and_link_provider.dart';
import 'network_connection_provider.dart';

///Get [App links and images]  from server
final updateImagesAndLinksProvider = FutureProvider<bool>((ref) async {
  ImageAndLinkList ial;
  var resultValue = false;
  var res = ref.read(networkAwareProvider).connectivityStatus;
  if (res != ConnectivityStatus.online) {
    if (HiveSettingsDB.imagesAndLinksJson.isNotEmpty) {
      var ialList = HiveSettingsDB.imagesAndLinksJson;
      ial = ImageAndLinkListMapper.fromJson(ialList);
    } else {
      return false;
    }
  } else {
    ial = await ImageAndLinkList.getImagesAndLinks();
    if (ial.imagesAndLinks == null || ial.rpcException != null) {
      if (!kIsWeb) FLog.warning(text: 'Error retrieving ${ial.rpcException}');
      return false;
    }
    resultValue = true;
  }

  for (ImageAndLink ial in ial.imagesAndLinks!) {
    switch (ial.key) {
      case 'mainSponsorLogo':
        ref.read(MainSponsorImageAndLink.provider.notifier).setValue(ial);
        break;
      case 'secondLogo':
        ref.read(SecondSponsorImageAndLink.provider.notifier).setValue(ial);
        break;
      case 'bladeguardLink':
        ref.read(BladeguardLinkImageAndLink.provider.notifier).setValue(ial);
        break;
      case 'startPoint':
        ref.read(StartPointImageAndLink.provider.notifier).setValue(ial);
        break;
      case 'defaultLongitude':
        if (ial.text == null) defaultLongitude = defaultAppLongitude;
        defaultLongitude = double.tryParse(ial.text!) ?? defaultAppLongitude;
        break;
      case 'androidPlayStoreLink':
        playStoreLink = ial.link ?? '';
        break;
      case 'iOSAppStoreLink':
        iOSAppStoreLink = ial.link ?? '';
        break;
      case 'liveMapLink':
        liveMapLink = ial.link ?? '';
        liveMapLinkText = ial.text ?? '';
        break;
      case 'openStreetMap': //disable OSM via remote
        if (ial.text != null && ial.text! == '') {
          //enable OSM via remote // if empty don't change
          HiveSettingsDB.removeOpenStreetMapLink();
        }
        if (ial.text != null && ial.text! == 'on') {
          //enable OSM via remote // if empty don't change
          HiveSettingsDB.setOpenStreetMapEnabled(true);
        }
        if (ial.text != null && ial.text! == 'off') {
          HiveSettingsDB.setOpenStreetMapEnabled(false);
        }
        if (ial.link != null && ial.link!.isNotEmpty) {
          try {
            var decodedLink = utf8.decode(base64.decode(ial.link!));
            HiveSettingsDB.setOpenStreetMapLink(decodedLink);
          } catch (e) {
            if (!kIsWeb) {
              FLog.error(
                  text:
                      'Could not decode open street map link link. Must be bas64encoded $e');
            }
          }
        }
        break;
      default:
        break;
    }
  }
  return resultValue;
});
