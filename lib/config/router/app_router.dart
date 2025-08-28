import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';

final appRouterProvider = Provider<GoRouter>(
  (ref) {
    //! Misma pregunta, por que uso read en lugar de watch.
    //* Nota goRouterNotifierProvider lee la información del notifier de authProvider y debido a que en el cuerpo del constructor del notifier
    //* se manda a llamar al método checkAuthStatus, esto hace que al iniciar la aplicación nosotros podamos cambiar y determinar cual es el
    //* authStatus del notifier del authProvider.
    final goRouterNotifier = ref.read(goRouterNotifierProvider);

    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: goRouterNotifier,
      routes: [
        //*Inital route
        GoRoute(
          path: '/splash',
          builder: (context, state) => const CheckAuthStatusScreen(),
        ),
        //* Auth Routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        ///* Product Routes
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductsScreen(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
            final productId = state.params['id'] ?? 'no-id';

            return ProductScreen(productId: productId);
          },
        ),
      ],

      redirect: (context, state) {
        final isGoingTo = state.subloc;
        final authStatus = goRouterNotifier.authStatus;

        if (isGoingTo == '/splash' && authStatus == AuthStatus.cheking) {
          return null;
        }

        if (authStatus == AuthStatus.notAuthenticated) {
          if (isGoingTo == '/login' || isGoingTo == '/register') return null;

          return '/login';
        }

        if (authStatus == AuthStatus.authenticated) {
          if (isGoingTo == '/login' ||
              isGoingTo == '/register' ||
              isGoingTo == '/splash') {
            return '/';
          }
        }

        return null;
      },

      ///! TODO: Bloquear si no se está autenticado de alguna manera
    );
  },
);
