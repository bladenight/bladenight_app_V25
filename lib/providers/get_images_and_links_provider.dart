import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_settings/app_configuration_helper.dart';
import '../helpers/hive_box/app_server_config_db.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger.dart';
import '../models/image_and_link.dart';
import '../models/images_and_links.dart';
import 'images_and_links/bladeguard_link_image_and_link_provider.dart';
import 'images_and_links/geofence_image_and_link_provider.dart';
import 'images_and_links/main_sponsor_image_and_link_provider.dart';
import 'images_and_links/second_sponsor_image_and_link_provider.dart';
import 'images_and_links/special_points_image_and_link_provider.dart';
import 'images_and_links/sponsors_image_and_link_provider.dart';
import 'images_and_links/startpoint_image_and_link_provider.dart';
import 'network_connection_provider.dart';

///Get [App links and images]  from server
final updateImagesAndLinksProvider = FutureProvider<bool>((ref) async {
  ImageAndLinkList ial;
  var resultValue = false;
  var res = ref.read(networkAwareProvider).connectivityStatus;
  if (res != ConnectivityStatus.wampConnected) {
    if (HiveSettingsDB.imagesAndLinksJson.isNotEmpty) {
      var ialList = HiveSettingsDB.imagesAndLinksJson;
      ial = ImageAndLinkListMapper.fromJson(ialList);
    } else {
      return false;
    }
  } else {
    ial = await ImageAndLinkList.getImagesAndLinks();
    if (ial.imagesAndLinks == null || ial.rpcException != null) {
      BnLog.warning(text: 'Error retrieving ${ial.rpcException}');
      return false;
    }
    resultValue = true;
  }

  for (ImageAndLink ial in ial.imagesAndLinks!) {
    switch (ial.key) {
      case 'sponsors':
        ref.read(sponsorsImageAndLinkProvider.notifier).setValue(ial);
        break;
      case 'mainSponsorLogo':
        ref.read(mainSponsorImageAndLinkProvider.notifier).setValue(ial);
        break;
      case 'secondLogo':
        ref.read(secondSponsorImageAndLinkProvider.notifier).setValue(ial);
        break;
      case 'bladeguardLink':
        ref.read(bladeguardImageAndLinkProvider.notifier).setValue(ial);
        break;
      case 'specialPoints':
        ref.read(specialPointsImageAndLinkProvider.notifier).setValue(ial);
        break;
      case 'geofence':
        ref.read(geofenceImageAndLinkProvider.notifier).setValue(ial);
        break;
      case 'restApiLink':
        ServerConfigDb.setRestApiLinkConfig(ial);
        break;
      case 'startPoint':
        ref.read(startpointImageAndLinkProvider.notifier).setValue(ial);
        break;
      case 'defaultLongitude':
        if (ial.text == null) {
          defaultLongitude = defaultAppLongitude;
          break;
        }
        defaultLongitude = double.tryParse(ial.text!) ?? defaultAppLongitude;
        break;
      case 'androidPlayStoreLink':
        playStoreLink = (ial.link ?? '').trim();
        break;
      case 'iOSAppStoreLink':
        iOSAppStoreLink = (ial.link ?? '').trim();
        break;
      case 'liveMapLink':
        liveMapLink = (ial.link ?? '').trim();
        liveMapLinkText = ial.text ?? '';
        break;
      case 'openStreetMap': //disable OSM via remote
        if (ial.text != null && ial.text!.trim() == '') {
          //enable OSM via remote // if empty don't change
          MapSettings.removeOpenStreetMapLink();
        }
        if (ial.text != null && ial.text!.trim() == 'on') {
          //enable OSM via remote // if empty don't change
          MapSettings.setOpenStreetMapEnabled(true);
        }
        if (ial.text != null && ial.text!.trim() == 'off') {
          MapSettings.setOpenStreetMapEnabled(false);
        }
        if (ial.link != null && ial.link!.isNotEmpty) {
          try {
            var decodedLink = utf8.decode(base64.decode(ial.link!.trim()));
            MapSettings.setOpenStreetMapLink(decodedLink);
          } catch (e) {
            if (!kIsWeb) {
              BnLog.error(
                  text:
                      'Could not decode open street map link. Must be base64encoded $e');
            }
          }
        }
        break;
      /*case 'openStreetMapDark': //disable OSM via remote
        if (ial.link != null && ial.link!.trim().isEmpty) {
          //enable OSM via remote // if empty remove link
          HiveSettingsDB.removeOpenStreetMapDarkLink();
        }
        if (ial.link != null && ial.link!.isNotEmpty) {
          try {
            var decodedLink = utf8.decode(base64.decode(ial.link!.trim()));
            HiveSettingsDB.setOpenStreetMapDarkLink(decodedLink);
          } catch (e) {
            if (!kIsWeb) {
              FLog.error(
                  text:
                      'Could not decode open street dark map link. Must be base64encoded $e');
            }
          }
        }

        ///Image contains subdomains for osm link
        if (ial.image != null && ial.image!.isNotEmpty) {
          MapSettings.setMapLinkSubdomains(ial.image!.trim());
        }
        break;*/
      case 'tileServerMapBoundsAndZoom':
        if (ial.link != null && ial.link!.trim() == '') {
          MapSettings.removeMapBoundaries();
        }
        if (ial.link != null && ial.link!.isNotEmpty) {
          try {
            MapSettings.setMapBoundaries(ial.link!);
          } catch (e) {
            if (!kIsWeb) {
              BnLog.error(
                  text: 'Could not decode setTileServerMapBoundsAndZoom: $e');
            }
          }
        }
        if (ial.text != null && ial.text!.isNotEmpty) {
          try {
            var content = ial.text!.split(',');
            if (content.length == 2) {
              MapSettings.setMinZoom(double.parse(content[0]));
              MapSettings.setMaxZoom(double.parse(content[1]));
            } else if (content.length == 4) {
              MapSettings.setMinZoom(double.parse(content[0]));
              MapSettings.setMaxZoom(double.parse(content[1]));
              MapSettings.setMinNativeZoom(int.parse(content[2]));
              MapSettings.setMaxNativeZoom(int.parse(content[3]));
            }
          } catch (e) {
            if (!kIsWeb) {
              BnLog.error(
                  text: 'Could not decode setTileServerMapBoundsAndZoom. $e');
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
