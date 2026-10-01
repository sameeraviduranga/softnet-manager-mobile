import 'package:dio/dio.dart';
import 'package:softnetmanager/core/storage/token_storage_service.dart';

class DioClient {
  final TokenStorageService _storageService;
  late final Dio dio;
  late final Dio refreshDio;

  DioClient(this._storageService) {
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
          if (error.response?.statusCode == 401) {
            //refresh flow
          }
          handler.next(error);
        },
      ),
    );
  }
}
