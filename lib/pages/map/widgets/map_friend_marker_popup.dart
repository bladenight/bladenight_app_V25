import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/timeconverter_helper.dart';
import '../../../models/bn_map_friend_marker.dart';
import '../../../pages/widgets/data_widget_left_right.dart';

class MapFriendMarkerPopup extends StatefulWidget {
  final BnMapFriendMarker marker;

  const MapFriendMarkerPopup(this.marker, {super.key});

  @override
  State<StatefulWidget> createState() => _MapFriendMarkerPopupState();
}

class _MapFriendMarkerPopupState extends State<MapFriendMarkerPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width * 0.8
            : MediaQuery.of(context).size.width * 0.5,
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
                  padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 30),
                    child: Row(
                      children: [
                        widget.marker.child,
                        const SizedBox(
                          width: 5,
                        ),
                        if (widget.marker.friend.specialValue == 0)
                          Text(
                            '${Localize.of(context).friend}: ${widget.marker.friend.name}',
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .navTitleTextStyle,
                          ),
                        if (widget.marker.friend.specialValue > 0)
                          Text(
                            widget.marker.friend.name,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .navTitleTextStyle,
                          ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  thickness: 2,
                  color: CupertinoTheme.of(context).primaryColor,
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
      padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          DataLeftRightContent(
              descriptionLeft: Localize.of(context).speed,
              descriptionRight:
                  '${widget.marker.friend.realSpeed.toStringAsFixed(1)} km/h',
              rightWidget: Container()),
          DataLeftRightContent(
              descriptionLeft: Localize.of(context).metersOnRoute,
              descriptionRight:
                  '${widget.marker.friend.specialValue > 0 ? widget.marker.friend.absolutePosition : widget.marker.friend.relativeDistance} m',
              rightWidget: Container()),
          DataLeftRightContent(
              descriptionLeft: 'Lat:',
              descriptionRight: widget.marker.point.latitude.toStringAsFixed(6),
              rightWidget: Container()),
          DataLeftRightContent(
              descriptionLeft: 'Lon:',
              descriptionRight:
                  widget.marker.point.longitude.toStringAsFixed(6),
              rightWidget: Container()),
          Divider(
            height: 2,
            color: CupertinoTheme.of(context).primaryColor,
            endIndent: 20,
          ),
          if (widget.marker.friend.specialValue == 0)
            DataLeftRightContent(
                descriptionLeft: Localize.of(context).timeToFinish,
                descriptionRight:
                    '${widget.marker.friend.relativeTime != null ? TimeConverter.millisecondsToDateTimeString(value: widget.marker.friend.relativeTime ?? 0) : '-'}',
                rightWidget: Container()),
          if (widget.marker.friend.specialValue == 0)
            Divider(
              height: 2,
              color: CupertinoTheme.of(context).primaryColor,
              endIndent: 20,
            ),
          if (widget.marker.friend.specialValue == 0)
            DataLeftRightContent(
                descriptionLeft:
                    '${widget.marker.friend.name} ${Localize.of(context).ist}',
                descriptionRight:
                    '${widget.marker.friend.timeToUser != null ? TimeConverter.millisecondsToDateTimeString(value: widget.marker.friend.timeToUser ?? 0) : '-'} ${(widget.marker.friend.timeToUser ?? 0).isNegative ? Localize.of(context).behindMe : Localize.of(context).aheadOfMe}',
                rightWidget: Container()),
          if (widget.marker.friend.specialValue == 0)
            DataLeftRightContent(
                descriptionLeft: '',
                descriptionRight:
                    '${widget.marker.friend.distanceToUser}m ${(widget.marker.friend.distanceToUser ?? 0).isNegative ? Localize.of(context).behindMe : Localize.of(context).aheadOfMe}',
                rightWidget: Container()),
        ],
      ),
    );
  }
}
