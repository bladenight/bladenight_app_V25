///Add _dark between last part of string separated by dot
///
/// for example
/// https://test.app/bn/skm.png
/// returns
/// https://test.app/bn/skm_dark.png
String getDarkName(String input) {
  var imgNameParts = input.split('.');
  if (imgNameParts.length >= 2) {
    var darkImgName = '';
    for (var count = 0; count < imgNameParts.length + 2; count++) {
      if (count < imgNameParts.length - 1) {
        darkImgName += imgNameParts[count];
      }
      if (count == imgNameParts.length) {
        darkImgName =
            '${darkImgName.substring(0, darkImgName.length - 2)}_dark';
        continue;
      }
      if (count == imgNameParts.length + 1) {
        darkImgName += '.${imgNameParts[imgNameParts.length - 1]}';
        return darkImgName;
      }
      darkImgName += '.';
    }
    return darkImgName;
  }
  return input;
}
