import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/shared_prefs_provider.dart';

class CustomLocationLayer extends StatefulWidget {
  const CustomLocationLayer({super.key});

  @override
  State<StatefulWidget> createState() => _CustomLocationLayer();
}

class _CustomLocationLayer extends State<CustomLocationLayer> {
  late final Stream<LocationMarkerPosition?> _positionStream;
  late final Stream<LocationMarkerHeading?> _headingStream;

  @override
  void initState() {
    super.initState();
    _positionStream =
        LocationProvider.instance.userLocationMarkerPositionStream;
    _headingStream = LocationProvider.instance.userLocationMarkerHeadingStream;
  }

  @override
  Widget build(BuildContext context) {
    return CurrentLocationLayer(
      positionStream: _positionStream,
      headingStream: _headingStream,
      alignPositionOnUpdate: AlignOnUpdate.never,
      alignDirectionOnUpdate: AlignOnUpdate.never,
      style: LocationMarkerStyle(
        marker: DefaultLocationMarker(
          child: CircleAvatar(
            backgroundColor: context.watch(MeColor.provider).withOpacity(0.6),
            child: LocationProvider.instance.userIsParticipant
                ?  ImageIcon(
                    const AssetImage('assets/images/skaterIcon_256_bearer.png'),
                    size: MediaQuery.textScalerOf(context)
                          .scale(HiveSettingsDB.iconSizeValue)-10,

                  )
                : const Icon(Icons.gps_fixed_sharp),
          ),
        ),
        markerSize: Size(
          MediaQuery.textScalerOf(context).scale(HiveSettingsDB.iconSizeValue),
          MediaQuery.textScalerOf(context).scale(HiveSettingsDB.iconSizeValue),
        ),
        markerDirection: MarkerDirection.heading,
      ),
    );
  }
}
