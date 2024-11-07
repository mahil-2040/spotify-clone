// core/error/failure.dart

class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => 'Failure(message: $message)';
}

class ServerFailure extends Failure {
  @override
  // ignore: overridden_fields
  final String message;
  ServerFailure(this.message) : super('');
}

class DataFormatFailure extends Failure {
  @override
  // ignore: overridden_fields
  final String message;
  DataFormatFailure(this.message) : super('');
}
