
import 'package:bladenight_app_flutter/models/realtime_update.dart';

late RealtimeUpdate _realtimeUpdate;
int _testCount = 0;

class RealTimeTest {
  Future<RealtimeUpdate> getTestRealtimeUpdate() async {
    await Future.delayed(const Duration(seconds: 10));
    switch (_testCount) {
      case 0:
        _realtimeUpdate = RealtimeUpdateMapper.fromJson(
            '{"hea":{"pos":17281,"spd":20,"eta":471010,"ior":true,"iip":true,"lat":48.12526909151467,"lon":11.599398275972768,"acc":0},'
            '"tai":{"pos":16663,"spd":0,"eta":1074225,"ior":true,"iip":true,"lat":48.12016726012295,"lon":11.59839572144946,"acc":0},'
            '"fri":{"fri":{"9":{"req":0,"fid":0,"onl":false,"pos":16865,"spd":13,"eta":720259,"ior":true,"iip":true,"lat":48.1219677066427,"lon":11.548752403193944,"acc":0}}},'
            '"up":{"pos":17000,"spd":16,"eta":710059,"ior":true,"iip":false,"lat":0.0,"lon":0.0,"acc":0},'
            '"rle":18452.0,"rna":"Ost","ust":4,"usr":4}');
        _testCount = 1;
        break;
      case 1:
        _realtimeUpdate = RealtimeUpdateMapper.fromJson(
            '{"hea":{"pos":14281,"spd":20,"eta":471010,"ior":true,"iip":true,"lat":48.10526909151467,"lon":10.549398275972768,"acc":0},'
            '"tai":{"pos":10663,"spd":0,"eta":1074225,"ior":true,"iip":true,"lat":48.10016726012295,"lon":10.54839572144946,"acc":0},'
            '"fri":{"fri":{"9":{"req":0,"fid":0,"onl":false,"pos":16865,"spd":13,"eta":720259,"ior":true,"iip":true,"lat":48.1219677066427,"lon":11.548752403193944,"acc":0}}},'
            '"up":{"pos":15000,"spd":16,"eta":710059,"ior":true,"iip":false,"lat":0.0,"lon":0.0,"acc":0},'
            '"rle":18452.0,"rna":"Ost","ust":4,"usr":4}');
        _testCount = 2;
        break;
      case 2:
        _realtimeUpdate = RealtimeUpdateMapper.fromJson(
            '{"hea":{"pos":9281,"spd":20,"eta":471010,"ior":true,"iip":true,"lat":48.06526909151467,"lon":12.549398275972768,"acc":0},'
            '"tai":{"pos":7663,"spd":0,"eta":1074225,"ior":true,"iip":true,"lat":48.03016726012295,"lon":12.54839572144946,"acc":0},'
            '"fri":{"fri":{"9":{"req":0,"fid":0,"onl":false,"pos":16865,"spd":13,"eta":720259,"ior":true,"iip":true,"lat":48.1219677066427,"lon":11.548752403193944,"acc":0}}},'
            '"up":{"pos":8000,"spd":16,"eta":710059,"ior":true,"iip":false,"lat":0.0,"lon":0.0,"acc":0},'
            '"rle":18452.0,"rna":"Ost","ust":4,"usr":4}');
        _testCount = 0;
        break;
    }
    return _realtimeUpdate;
  }
}
