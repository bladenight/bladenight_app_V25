import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/bn_map_marker.dart';
import '../../../pages/widgets/data_widget_left_right.dart';

class MapMarkerPopup extends StatefulWidget {
  final BnMapMarker marker;

  const MapMarkerPopup(this.marker, {super.key});

  @override
  State<StatefulWidget> createState() => _MapMarkerPopupState();
}

class _MapMarkerPopupState extends State<MapMarkerPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:
              CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.65),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.65),
              blurRadius: 4,
              spreadRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Builder(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 5),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 30),
                    child: Row(
                      children: [
                        widget.marker.child,
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.marker.headerText,
                          overflow: TextOverflow.ellipsis,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: CupertinoTheme.of(context).primaryColor,
                  height: 2,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                _cardDescription(context),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 20, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (widget.marker.speedText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).speed,
                descriptionRight: widget.marker.speedText ?? '',
                rightWidget: Container()),
          if (widget.marker.drivenDistanceText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).distanceDriven,
                descriptionRight: widget.marker.drivenDistanceText ?? '',
                rightWidget: Container()),
          DataLeftRightContent(
              descriptionLeft: Localize.of(context).position,
              descriptionRight:
                  'Lat:${widget.marker.point.latitude.toStringAsFixed(6)} Lon:${widget.marker.point.longitude.toStringAsFixed(6)}',
              rightWidget: Container()),
          if (widget.marker.timeUserToHeadText != null)
            Divider(
              height: 2,
              color: CupertinoTheme.of(context).primaryColor,
              endIndent: 20,
            ),
          if (widget.marker.timeUserToHeadText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).head,
                descriptionRight: '',
                rightWidget: Container()),
          if (widget.marker.timeUserToHeadText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).timeToMe,
                descriptionRight: widget.marker.timeUserToHeadText ?? '',
                rightWidget: Container()),
          if (widget.marker.distanceUserToHeadText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).distance,
                descriptionRight: widget.marker.distanceUserToHeadText ?? '',
                rightWidget: Container()),
          if (widget.marker.timeUserToTailText != null)
            Divider(
              height: 2,
              color: CupertinoTheme.of(context).primaryColor,
              endIndent: 20,
            ),
          if (widget.marker.timeUserToTailText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).tail,
                descriptionRight: '',
                rightWidget: Container()),
          if (widget.marker.timeUserToTailText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).timeToMe,
                descriptionRight: widget.marker.timeUserToTailText ?? '',
                rightWidget: Container()),
          if (widget.marker.distanceUserToTailText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).distance,
                descriptionRight: widget.marker.distanceUserToTailText ?? '',
                rightWidget: Container()),
          if (widget.marker.timeToTailText != null ||
              widget.marker.distanceTailText != null)
            Divider(
              height: 2,
              color: CupertinoTheme.of(context).primaryColor,
              endIndent: 20,
            ),
          if (widget.marker.timeToTailText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).timeToTail,
                descriptionRight: widget.marker.timeToTailText ?? '',
                rightWidget: Container()),
          if (widget.marker.distanceTailText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).distanceToTail,
                descriptionRight: widget.marker.distanceTailText ?? '',
                rightWidget: Container()),
          if (widget.marker.timeToHeadText != null)
            Divider(
              height: 2,
              color: CupertinoTheme.of(context).primaryColor,
              endIndent: 20,
            ),
          if (widget.marker.timeToHeadText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).timeToHead,
                descriptionRight: widget.marker.timeToHeadText ?? '',
                rightWidget: Container()),
          if (widget.marker.distanceToHeadText != null)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).distanceToHead,
                descriptionRight: widget.marker.distanceToHeadText ?? '',
                rightWidget: Container()),
        ],
      ),
    );
  }
}
