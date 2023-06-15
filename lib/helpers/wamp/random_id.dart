import 'dart:math';

String randomId() {
  var random = Random();
  var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(16, (index) => chars[random.nextInt(chars.length)])
      .join();
}
