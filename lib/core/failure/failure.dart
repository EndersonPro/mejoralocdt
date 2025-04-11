class Failure {
  final String message;

  Failure({required this.message});

  @override
  String toString() {
    return 'Failure{message: $message}';
  }
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}
