import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:softnetmanager/core/locators/locator.dart';
import 'package:softnetmanager/core/router/auth_notifier.dart';
import 'package:softnetmanager/core/storage/token_storage_service.dart';
import 'package:softnetmanager/features/auth/cubit/AuthSessionManager.dart';
import 'package:softnetmanager/features/auth/data/models/login_request.dart';
import 'package:softnetmanager/features/auth/data/models/refresh_request.dart';
import 'package:softnetmanager/features/auth/domain/repository/auth_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final TokenStorageService tokenStorageService;
  final AuthSessionmanager _authSessionmanager;
  final _authNotifier = getIt<AuthNotifier>();
  AuthCubit(
    this._authRepository,
    this.tokenStorageService,
    this._authSessionmanager,
  ) : super(AuthInitial());

  //=============================
  //login
  //=============================
  Future<void> login({required String email, required String password}) async {
    _emit(AuthLoading());
    try {
      var result = await _authRepository.login(
        LoginRequest(email: email, password: password),
      );

      result.fold((failure) => _emit(AuthError(failure.message)), (
        response,
      ) async {
        await tokenStorageService.saveTokens(
          accessToken: response.data!.token,
          refreshToken: response.data!.refreshToken,
        );
        _authSessionmanager.authenticated();
        _emit(AuthAuthenticated());
      });
    } catch (e) {
      _emit(AuthError(e.toString()));
    }
  }

  //=============================
  //restore session
  //=============================

  Future<void> restoreSession() async {
    _emit(AuthRestoring());
    try {
      final accessToken = await tokenStorageService.getAccessToken();
      final refreshToken = await tokenStorageService.getRefreshToken();

      if (accessToken != null && refreshToken != null) {
        if (JwtDecoder.isExpired(accessToken)) {
          var result = await _authRepository.refreshToken(
            RefreshRequest(refreshToken: refreshToken),
          );
          result.fold(
            (failure) {
              _authSessionmanager.unauthenticated();
              _emit(AuthUnauthenticated());
            },
            (response) async {
              await tokenStorageService.saveTokens(
                accessToken: response.data!.token,
                refreshToken: response.data!.refreshToken,
              );
              _authSessionmanager.authenticated();
              _emit(AuthAuthenticated());
            },
          );
        } else {
          _authSessionmanager.authenticated();
          _emit(AuthAuthenticated());
        }
      } else {
        await clearSession();
      }
    } catch (e) {
      _emit(AuthError(e.toString()));
    }
  }

  Future<void> clearSession() async {
    await tokenStorageService.clearTokens();
    _authSessionmanager.unauthenticated();
    _emit(AuthUnauthenticated());
  }

  //=============================
  //logout
  //=============================
  Future<void> logout() async {
    _emit(AuthLoading());
    try {
      await tokenStorageService.clearTokens();
      _authSessionmanager.unauthenticated();
      _emit(AuthUnauthenticated());
    } catch (e) {
      _emit(AuthError(e.toString()));
    }
  }

  void _emit(AuthState state) {
    emit(state);
    _authNotifier.notify();
  }
}
