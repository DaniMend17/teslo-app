import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

//*Provider que me va a servir para poder realizar la inyección de dependencias hacia el provider principal que es
//*el que realmente me mostrará los productos.
final productsRepositoryProvider = Provider<ProductsRepository>(
  (ref) {

    //*Si el usuario es nulo entonces no tiene access token y por lo tanto
    //*Si se realiza una petición el token sera vacio por tanto la petición nos mandara error de autenticación.
    final accessToken = ref.watch(authProvider).user?.token ?? '';

    return ProductsRepositoryImpl(
        datasource: ProductsDatasourceImpl(accessToken: accessToken));
  },
);
