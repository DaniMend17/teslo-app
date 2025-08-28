import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

//! 3.StateNotifierProvider - consumido por los widgets.
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallback);
});

//! 2.El notifier que manejara nuestro provider.
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Future<void> Function(String email, String password) loginUserCallback;

  LoginFormNotifier(this.loginUserCallback) : super(const LoginFormState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([state.email, newPassword]),
    );
  }

  Future<void> onFormSubmmit() async {
    _touchEveryField();
    if (!state.isValid) return;

    state = state.copyWith(isFormPosting: true);

    await loginUserCallback(state.email.value, state.password.value);

    state = state.copyWith(isFormPosting: false);  
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([state.email, state.password]));
  }
}

//! 1.El state que va a manejar nuestro provider.
class LoginFormState {
  //*Lo utilzo para saber si el formulario esta siendo procesado por la api.
  final bool isFormPosting;
  //*Lo utilizo para saber si el formalario ya ha sido ensuciado. Es decir ya contiene información para mandar.
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  const LoginFormState(
      {this.isFormPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  @override
  String toString() {
    return '''
  LoginFormState:
    isPosting: $isFormPosting
    isPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
    ''';
  }

  LoginFormState copyWith({
    bool? isFormPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) {
    return LoginFormState(
      isFormPosting: isFormPosting ?? this.isFormPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
