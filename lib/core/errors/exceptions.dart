class AiLimitReachedException implements Exception {
  final String message;
  const AiLimitReachedException([this.message = 'AI limit reached']);

  @override
  String toString() => message;
}

class AiTimeoutException implements Exception {
  final String message;
  const AiTimeoutException([this.message = 'AI request timed out']);

  @override
  String toString() => message;
}

class InvalidJsonException implements Exception {
  final String message;
  const InvalidJsonException([this.message = 'Invalid JSON response']);

  @override
  String toString() => message;
}
