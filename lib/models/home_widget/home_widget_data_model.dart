import 'package:dart_mappable/dart_mappable.dart';

part 'home_widget_data_model.mapper.dart';

@MappableClass()
class HomeWidgetDataModel with HomeWidgetDataModelMappable {
  @MappableField()
  double? progress = 0.0;
  @MappableField()
  double? speed = 0.0;
  @MappableField()
  double? odoMeter = 0.0;
  @MappableField()
  double? processionLength = 0.0;
  @MappableField()
  String? eventStatus;
  @MappableField()
  String? route;
  @MappableField()
  String? date;
  @MappableField()
  String? length;
}
