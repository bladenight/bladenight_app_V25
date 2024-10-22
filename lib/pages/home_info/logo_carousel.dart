import 'package:flutter/cupertino.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../helpers/url_launch_helper.dart';
import '../../providers/images_and_links/main_sponsor_image_and_link_provider.dart';
import '../../providers/images_and_links/second_sponsor_image_and_link_provider.dart';

class LogoCarousel extends ConsumerWidget {
  const LogoCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterCarousel(
        options: FlutterCarouselOptions(
            height: 50,
            autoPlay: true,
            showIndicator: false,
            scrollDirection: Axis.horizontal),
        items: [
          GestureDetector(
            onTap: () async {
              var link = ref.read(mainSponsorImageAndLinkProvider).link;
              if (link != null && link != '') {
                var uri =
                    Uri.parse(ref.read(mainSponsorImageAndLinkProvider).link!);
                Launch.launchUrlFromUri(uri);
              }
            },
            child: Builder(builder: (context) {
              return Image.asset(skmLogoPlaceholder, fit: BoxFit.contain);
            }),
          ),
          GestureDetector(
            onTap: () {
              var link = ref.read(secondSponsorImageAndLinkProvider).link;
              if (link != null && link != '') {
                var uri = Uri.parse(
                    ref.read(secondSponsorImageAndLinkProvider).link!);
                Launch.launchUrlFromUri(uri);
              }
            },
            child: Builder(builder: (context) {
              return Image.asset(bnLogoPlaceholder, fit: BoxFit.contain);
            }),
          ),
        ]);
  }
}
