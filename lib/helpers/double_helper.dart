//returns a shorter less exactly double on given [decimalPlaces]
extension DoubleExtension on double {
  double toShortenedDouble(int decimalPlaces) {
    var doubleString = toStringAsFixed(decimalPlaces);
    var shortDouble = double.tryParse(doubleString);
    if (shortDouble != null) return shortDouble;
    return this;
  }
}
