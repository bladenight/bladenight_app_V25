class BadResultException implements Exception {
  String reason;

  BadResultException(this.reason);
}
