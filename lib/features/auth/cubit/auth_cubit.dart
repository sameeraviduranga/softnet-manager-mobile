import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:softnetmanager/core/locators/locator.dart';
import 'package:softnetmanager/core/router/auth_notifier.dart';
import 'package:softnetmanager/core/storage/token_storage_service.dart';
import 'package:softnetmanager/features/auth/data/models/login_request.dart';
import 'package:softnetmanager/features/auth/data/models/login_response.dart';
import 'package:softnetmanager/features/auth/domain/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final TokenStorageService tokenStorageService;
  final _authNotifier = getIt<AuthNotifier>();
  AuthCubit(this._authRepository, this.tokenStorageService)
    : super(AuthInitial());

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
        _emit(AuthSuccess(response));
      });
    } catch (e) {
      _emit(AuthError(e.toString()));
    }
  }

  void _emit(AuthState state) {
    emit(state);
    _authNotifier.notify();
  }
}
