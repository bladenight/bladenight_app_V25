import 'package:dart_mappable/dart_mappable.dart';
import 'package:latlong2/latlong.dart';

part 'sponsors.mapper.dart';

@MappableClass()
class Sponsor with SponsorMappable {
  @MappableField(key: 'rem')
  final String? remark;
  @MappableField(key: 'img')
  final String imageName;
  @MappableField(key: 'ilk')
  final String imageUrl;
  @MappableField(key: 'des')
  final String description;
  @MappableField(key: 'url')
  final String? url;
  @MappableField(key: 'idx')
  final int index;

  Sponsor(this.remark, this.imageName, this.imageUrl, this.description,
      this.url, this.index) {}
}

@MappableClass()
class Sponsors with SponsorsMappable {
  @MappableField(key: 'spo')
  final List<Sponsor> sponsors;

  Sponsors(this.sponsors);
}
