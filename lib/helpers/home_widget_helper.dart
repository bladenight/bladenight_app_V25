import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';

import '../models/event.dart';
import '../models/home_widget/home_widget_data_model.dart';
import '../providers/active_event_provider.dart';

class HomeWidgetHelper_ {
  static HomeWidgetHelper_? _instance;
  static const widgetGroup = 'app.huth.bn.Bladenight-HomeWidget';

  HomeWidgetHelper_._privateConstructor() {
    _init();
  }

  //instance factory
  factory HomeWidgetHelper_() {
    _instance ??= HomeWidgetHelper_._privateConstructor();
    return _instance!;
  }

  void _init() {
    /* HomeWidget.setAppGroupId('app.huth.bn.Bladenight-HomeWidget');
    var widgets = HomeWidget.getInstalledWidgets();*/
  }

  static updateEvent(Event event) async {
    if (!Platform.isIOS || !Platform.isAndroid) {
      return;
    }
    var data = HomeWidgetDataModel();
    event = ProviderContainer().read(activeEventProvider);
    //convert to WatchEventModel included translations
    data.length = event.routeLength.toString();
    /* var widgets = await HomeWidget.getInstalledWidgets();
    var sent = await HomeWidget.saveWidgetData('data', data.toJson());
    await HomeWidget.updateWidget(
      name: 'HomeWidgetExampleProvider',
      iOSName: 'HomeWidgetExample',
    );*/
  }

  static updateRealtimeData(bg.Location location) {
    if (!Platform.isIOS) {
      return;
    }
    var data = HomeWidgetDataModel();
    data.odoMeter = location.odometer / 1000;
    data.speed = location.coords.speed;
    data.route = 'route ${DateTime.now().toIso8601String()}';
    data.eventStatus = 'evtroute ${DateTime.now().toIso8601String()}';

    // HomeWidget.saveWidgetData('Bladenight HomeWidget', data.toJson());
  }

  static setIsLocationTracking(bool isTracking) {
    if (!Platform.isIOS) {
      return;
    }
  }
}
//}
