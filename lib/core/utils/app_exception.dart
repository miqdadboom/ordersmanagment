// core/utils/app_exception.dart
class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  NoInternetException() : super('No internet connection. Please check your connection and try again.');
}

class ServerException extends AppException {
  ServerException(String msg) : super('Server error: $msg');
}

class ParseException extends AppException {
  ParseException() : super('Data format error. Please try again.');
}

class UnknownException extends AppException {
  UnknownException(String msg) : super('Unexpected error: $msg');
}

class TimeoutException extends AppException {
  TimeoutException() : super('Connection timeout. Please try again.');
}

class ConnectionException extends AppException {
  ConnectionException() : super('Failed to connect to server. Please check your connection and try again.');
}