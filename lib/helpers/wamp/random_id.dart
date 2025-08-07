import 'dart:math';

int randomId() {
  var random = Random();
  var chars = '0123456789';
  var number = List.generate(10, (index) => chars[random.nextInt(chars.length)])
      .join();
  //return DateTime.now().millisecondsSinceEpoch.toInt();
  return int.parse(number);
}
