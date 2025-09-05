import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

final goRouterNotifierProvider = Provider<AppRouterNotifier>(
  (ref) {
    //! Por que razón aqui estoy usando read en lugar de watch que es la recomendación de riverpod,
    //! hay alguna diferencia si uso watch en lugar de read??

    //* En este caso authNotifier esta accediendo al notifier del authProvider, PERO AÚN ASÍ RIVERPOD  SIEMPRE CREARA PRIMERO
    //* LA INSTANCIA DEL PROVIDER EN SÍ Y DESPUES YA INSTANCIADO EL PROVIDER PROCEDERÁ A INSTANCIAR A SU NOTIFIER Y SUCESIVAMENTE
    //* EL NOTIFIER PROCEDERA A INSTANCIAR EL ESTADO. DEBIDO A ESTO ES QUE A PESAR DE QUE AQUI UNICAMENTE ESTAMOS PIDIENDO EL NOTIFIER
    //* AUTOMATICAMENTE TAMBIEN ESTAMOS INSTANCIANDO  EL PROVIDER COMPLETO (PROVIDER, NOTIFIER, STATE).
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
        if (authStatus == state.authStatus) return;

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
