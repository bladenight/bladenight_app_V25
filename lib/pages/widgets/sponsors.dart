import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Card, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart' show Localize;
import '../../helpers/file_name_helper.dart';
import '../../helpers/logger/logger.dart';
import '../../helpers/url_launch_helper.dart' show Launch;
import '../../providers/sponsors_provider.dart';

class SponsorCarousel extends ConsumerStatefulWidget {
  const SponsorCarousel({this.height = 60, super.key});

  final double height;

  @override
  ConsumerState<SponsorCarousel> createState() => _SponsorCarouselState();
}

class _SponsorCarouselState extends ConsumerState<SponsorCarousel> {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).height > 500) {
      return SizedBox(
          height: widget.height,
          child: Column(
            children: [_header(maxLines: 1), _carousel],
          ));
    } else if (MediaQuery.sizeOf(context).width > 500) {
      return SizedBox(
        height: widget.height,
        child: Row(
          children: [_carousel],
        ),
      );
    }
    return SizedBox(
      height: widget.height,
      child: _carousel,
    );
  }

  Widget _header({required int maxLines}) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        Localize.of(context).sponsors,
        maxLines: maxLines,
        style: TextStyle(fontSize: MediaQuery.of(context).textScaler.scale(8)),
      ),
    );
  }

  Widget get _carousel {
    return Expanded(
      child: Builder(builder: (context) {
        var sponsors = ref.watch(sponsorsProvider);
        if (sponsors.hasValue && sponsors.value!.isNotEmpty) {
          return SizedBox(
            height: widget.height,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  scrollDirection: Axis.horizontal,
                  autoPlayInterval: Duration(seconds: 4),
                  autoPlay: (sponsors.value!.length).round() > 1 ? true : false,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  enlargeFactor: 0.4,
                  viewportFraction: 1,
                ),
                //controller: _sponsorScrollController,
                //physics: ClampingScrollPhysics(),
                itemCount: (sponsors.value!.length).round(),
                itemBuilder: (context, index, realIdx) {
                  return Card(
                    color: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    //bg color for card
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (sponsors.value![index].url != null) {
                            Launch.launchUrlFromString(
                                sponsors.value![index].url!,
                                sponsors.value![index].description);
                          }
                        },
                        child: Builder(builder: (context) {
                          var imageName = sponsors.value![index].imageUrl;
                          if (CupertinoTheme.brightnessOf(context) ==
                              Brightness.light) {
                            imageName = getDarkName(imageName);
                          }
                          return CachedNetworkImage(
                              //height: 80,
                              width: MediaQuery.sizeOf(context).width * 0.66,
                              fit: BoxFit.contain,
                              placeholder: (c, s) {
                                return Text(
                                  sponsors.value![index].description,
                                );
                              },
                              imageUrl: imageName,
                              fadeOutDuration:
                                  const Duration(milliseconds: 300),
                              fadeInDuration: const Duration(milliseconds: 300),
                              errorWidget: (context, url, error) => Center(
                                    child: Text(
                                      sponsors.value![index].description,
                                    ),
                                  ),
                              errorListener: (e) {
                                BnLog.warning(
                                  text:
                                      'The sponsor image error ${sponsors.value![index].imageUrl} ${e.toString()}) could not been loaded',
                                );
                              }

                              /* Image.asset(
                                                        emptySponsorPlaceholder,
                                                        fit: BoxFit.fill);*/

                              );
                        }),
                      ),
                    ),
                  );
                }),
          );
        }
        return Container();
      }),
    );
  }
}
