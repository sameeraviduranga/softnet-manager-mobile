import 'package:softnetmanager/core/network/dio_client.dart';
import 'package:softnetmanager/features/auth/data/models/login_request.dart';
import 'package:softnetmanager/features/auth/data/models/login_response.dart';
import 'package:softnetmanager/features/auth/data/models/refresh_request.dart';

class AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSource(this._client);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _client.dio.post("/Auth", data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }

  Future<LoginResponse> refreshToken(RefreshRequest request) async {
    final response = await _client.dio.post(
      "/Auth/RefreshToken",
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  //remove
  Future<String?> getProduct() async {
    final response = await _client.dio.get('/Products/GetProduct/1');
    return response.data;
  }
}
