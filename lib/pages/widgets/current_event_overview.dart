import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/location_bearing_distance.dart';
import '../../helpers/timeconverter_helper.dart';
import '../../models/bn_map_marker.dart';
import '../../models/event.dart';
import '../../models/route.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/map/icon_size_provider.dart';
import '../../providers/route_providers.dart';
import '../home_info/event_data_overview.dart';
import '../home_info/event_map_small.dart';
import 'data_loading_indicator.dart';
import 'event_info/map_layer_overview.dart';
import 'hidden_admin_button.dart';
import 'no_data_warning.dart';

class CurrentEventOverview extends ConsumerStatefulWidget {
  const CurrentEventOverview({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentEventOverview();
}

class _CurrentEventOverview extends ConsumerState<CurrentEventOverview>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final double _borderRadius = 15;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 10000), vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var nextEvent = ref.watch(activeEventProvider);

    return SafeArea(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, _) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).barBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_borderRadius),
                    bottomLeft: Radius.circular(_borderRadius),
                    bottomRight: Radius.circular(_borderRadius),
                    topRight: Radius.circular(_borderRadius)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: nextEvent.statusColor,
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: ResponsiveRowColumn(
                rowCrossAxisAlignment: CrossAxisAlignment.center,
                columnCrossAxisAlignment: CrossAxisAlignment.center,
                columnMainAxisSize: MainAxisSize.max,
                rowMainAxisSize: MainAxisSize.max,
                rowPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                columnPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                columnSpacing: 1,
                rowSpacing: 1,
                layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
                children: [
                  ResponsiveRowColumnItem(
                    columnFit: FlexFit.tight,
                    rowFit: FlexFit.tight,
                    child: SizedBox(
                      height: 250,
                      width: 300,
                      child: EventMapSmall(
                        nextEvent: nextEvent,
                        borderRadius: _borderRadius,
                      ),
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    child: SizedBox(
                      height: 250,
                      width: 200,
                      child: EventDataOverview(
                        nextEvent: nextEvent,
                        parentAnimationController: _animationController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //),
          );
        },
      ),
    );
  }
}
