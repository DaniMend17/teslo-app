import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/key_value_storage_service_impl.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

enum AuthStatus { cheking, authenticated, notAuthenticated }

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final AuthRepositoryImpl repository = AuthRepositoryImpl();
  final KeyValueStorageServiceImpl service = KeyValueStorageServiceImpl();

  return AuthNotifier(repository, service);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryImpl repository;
  final KeyValueStorageServiceImpl service;

  AuthNotifier(this.repository, this.service) : super(const AuthState()) {
    checkAuthStatus();
  }

  void checkAuthStatus() async {
    final token = await service.getValue<String>('token');
    if (token == null) return logout();
    try {
      final user = await repository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await repository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Erro no controlado');
    }
  }

  Future<void> registerUser(String email, String password, String name) async {
    try {
      final user = await repository.register(email, password, name);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      // print(e.message);
      // state = state.copyWith(errorMessage: e.message);
      logout(e.message);
    } catch (e) {
      logout('Erro no controlado');
    }
  }

  void _setLoggedUser(User user) async {
    await service.setKeyValue('token', user.token);
    state = state.copyWith(
        authStatus: AuthStatus.authenticated, user: user, errorMessage: '');
  }

  void logout([String errorMessage = '']) async {
    await service.removeKey('token');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  const AuthState(
      {this.authStatus = AuthStatus.cheking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

}
