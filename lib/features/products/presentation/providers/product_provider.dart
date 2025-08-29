import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import 'providers.dart';

final productProvider = StateNotifierProvider.family
    .autoDispose<ProductNotifier, ProductState, String>(
  (ref, productId) {
    final repository = ref.watch(productsRepositoryProvider);
    return ProductNotifier(repository: repository, productId: productId);
  },
);

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository repository;

  //*Nota este constructor le esta pasando un String al constructor del state, mediante
  //*uno de sus argumentos en el constructor.
  ProductNotifier({required this.repository, required String productId})
      : super(ProductState(id: productId)) {
    getProductById();
  }

  Future<void> getProductById() async {
    final product = await repository.getProductById(state.id);
    state = state.copyWith(
      isLoading: false,
      product: product,
    );
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState(
      {required this.id,
      this.product,
      this.isLoading = true,
      this.isSaving = false});

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) {
    return ProductState(
      id: id ?? this.id,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
