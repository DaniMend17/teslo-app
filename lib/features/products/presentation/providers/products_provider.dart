// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import '../presentation.dart';

  //! El provider
  final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
    
    final repository = ref.watch(productsRepositoryProvider);

    return ProductsNotifier(productsRepository: repository);

  },);




//! El notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  //*Cuando nosotros observemos este provider inmediatemente mandaremos a llamar el método loadNextPage y recuperaremos
  //*los productos.
  ProductsNotifier({required this.productsRepository}) : super(ProductsState()) {
    loadNextPage();
  }


  //*Recordar que este método esta pensado para un infinite scroll, el cual sera disparado cada que el usuario llegué
  //*a la parte final del scroll y parará hasta obtener todos los productos del repositorio.
  Future<void> loadNextPage() async {
    
    if(state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsByPage(limit: state.limit, offset: state.offset);

    if(products.isEmpty){
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products],
    );


  }
}

//! El state que voy a manejar para este provider será en si uno que me ayude a mantener los productos que estoy mostrando
//! en pantalla al usuario.
class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState(
      {this.isLastPage = false,
      this.limit = 10,
      this.offset = 0,
      this.isLoading = false,
      this.products = const []});

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) {
    return ProductsState(
      isLastPage: isLastPage ?? this.isLastPage,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
    );
  }
}
