import 'package:dio/dio.dart';
import 'package:softnetmanager/core/storage/token_storage_service.dart';
import 'package:softnetmanager/features/auth/cubit/AuthSessionManager.dart';

class DioClient {
  final TokenStorageService _storageService;
  final AuthSessionmanager _authSessionmanager;
  late final Dio dio;
  late final Dio refreshDio;
  Future<bool>? _refreshFuture;

  DioClient(this._storageService, this._authSessionmanager) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.100:5001/api', //ipaddress
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        sendTimeout: Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    refreshDio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.100:5001/api', //ipaddress
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        sendTimeout: Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _storageService.getAccessToken();

          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode != 401) {
            handler.next(error);
            return;
            //refresh flow
          }
          final refreshed = await _refreshAccessToken();

          if (!refreshed) {
            handler.next(error);
            return;
          }

          try {
            final accessToken = await _storageService.getAccessToken();

            final requestOptions = error.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $accessToken';
            final response = await dio.fetch(requestOptions);
            handler.resolve(response);
          } catch (_) {
            handler.next(error);
          }
        },
      ),
    );
  }

  //======================================
  //RefreshMethod
  //======================================

  Future<bool> _refreshAccessToken() async {
    if (_refreshFuture != null) {
      return await _refreshFuture!;
    }

    _refreshFuture = _performRefresh();

    try {
      return await _refreshFuture!;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<bool> _performRefresh() async {
    final refreshToken = await _storageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await handleRefreshFailure();
      return false;
    }
    try {
      final response = await refreshDio.post(
        'Auth/RefreshToken',
        data: {"RefreshToken": refreshToken, "ClientId": "Client1"},
      );

      final newaccessToken = response.data['Token'];
      final newrefreshToken = response.data['RefreshToken'];

      await _storageService.saveTokens(
        accessToken: newaccessToken,
        refreshToken: newrefreshToken,
      );

      return true;
    } catch (_) {
      await handleRefreshFailure();
      return false;
    }
  }

  //======================================
  //ClearTokens
  //======================================
  Future<void> handleRefreshFailure() async {
    await _storageService.clearTokens();
    _authSessionmanager.unauthenticated();
  }
}
