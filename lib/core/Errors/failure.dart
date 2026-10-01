class Failure {
  String message;
  Failure(this.message);
}

final class UnAuthorizedFailure extends Failure {
  UnAuthorizedFailure(super.message);
}

final class ServerFailure extends Failure {
  ServerFailure(super.message);
}

final class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

final class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
