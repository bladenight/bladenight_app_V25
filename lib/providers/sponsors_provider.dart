import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/logger.dart';
import '../models/sponsors.dart';
import 'get_images_and_links_provider.dart';
import 'images_and_links/sponsors_image_and_link_provider.dart';

part 'sponsors_provider.g.dart';

@riverpod
class Sponsors extends _$Sponsors {
  @override
  Future<List<Sponsor>> build() async {
    List<Sponsor> sponsorList = [];
    var pointsJson = ref.watch(sponsorsImageAndLinkProvider).text;
    if (pointsJson != null) {
      try {
        sponsorList = SponsorsMapper.fromJson(pointsJson).sponsors;
        sponsorList.sort((a, b) => a.index.compareTo(b.index));
      } catch (e) {
        BnLog.error(text: 'Sponsors parse error $e', className: toString());
      }
    }
    return sponsorList;
  }
}
