import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:softnetmanager/core/Errors/failure.dart';
import 'package:softnetmanager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:softnetmanager/features/auth/data/models/login_request.dart';
import 'package:softnetmanager/features/auth/data/models/login_response.dart';

abstract class IAuthrepository {
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);
}

class AuthRepository implements IAuthrepository {
  final AuthRemoteDataSource _remoteDataSource;
  final InternetConnectionChecker _connectionChecker;

  AuthRepository(this._remoteDataSource, this._connectionChecker);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    if (!await _connectionChecker.hasConnection) {
      return left(Failure("Internet connection"));
    }
    try {
      final response = await _remoteDataSource.login(request);

      return right(response);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return left(UnAuthorizedFailure("Invalid credential"));
      }
      if (e.type == DioExceptionType.connectionError) {
        return left(NetworkFailure('Unable to connect to server.'));
      }
      return left(ServerFailure(e.message ?? 'Server error occurred.'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
