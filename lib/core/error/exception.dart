abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class DatabaseException extends AppException {
  DatabaseException(super.message);
}
