import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

final goRouterNotifierProvider = Provider<AppRouterNotifier>(
  (ref) {
    //! Por que razón aqui estoy usando read en lugar de watch que es la recomendación de riverpod,
    //! hay alguna diferencia si uso watch en lugar de read??
    final authNotifier = ref.read(authProvider.notifier);

    return AppRouterNotifier(authNotifier);
  },
);

class AppRouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;
  AuthStatus _authStatus = AuthStatus.cheking;

  AppRouterNotifier(this._authNotifier) {
    _authNotifier.addListener(
      (state) {
        authStatus = state.authStatus;

      },
    );
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }

}
