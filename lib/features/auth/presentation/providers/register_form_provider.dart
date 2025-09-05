// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

//! Provider

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFromNotifier, RegisterFormState>(
  (ref) {
    final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
    return RegisterFromNotifier(registerUserCallback: registerUserCallback);
  },
);

//! Notifier
class RegisterFromNotifier extends StateNotifier<RegisterFormState> {
  final Future<void> Function(String email, String password, String fullName)
      registerUserCallback;

  RegisterFromNotifier({required this.registerUserCallback})
      : super(RegisterFormState(
            name: 'daniel', email: 'd@google.com', password: 'Abc123'));

  Future<void> onFormSubmmit() async {
    state = state.copyWith(isPosting: true);
    await registerUserCallback(state.email, state.password, state.name);
    state = state.copyWith(isPosting: false);
  }
}

//! State
class RegisterFormState {
  final bool isPosted;
  final bool isPosting;
  final bool isValid;
  final String name;
  final String email;
  final String password;

  RegisterFormState(
      {this.isPosted = false,
      this.isPosting = false,
      this.isValid = false,
      this.name = '',
      this.email = '',
      this.password = ''});

  RegisterFormState copyWith({
    bool? isPosted,
    bool? isPosting,
    bool? isValid,
    String? name,
    String? email,
    String? password,
  }) {
    return RegisterFormState(
      isPosted: isPosted ?? this.isPosted,
      isPosting: isPosting ?? this.isPosting,
      isValid: isValid ?? this.isValid,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
