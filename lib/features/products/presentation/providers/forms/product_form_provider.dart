import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/environment.dart';

import '../../../../shared/infrastructure/inputs/inputs.dart';
import '../../../domain/domain.dart';
import '../../presentation.dart';

final productFormProvider = StateNotifierProvider.family
    .autoDispose<ProductFormNotifier, ProductFormState, Product>(
  (ref, product) {
    // final createUpdateProductCallback =
    //     ref.watch(productsRepositoryProvider).createUpdateProduct;

    final createUpdateProductCallback =
        ref.watch(productsProvider.notifier).createUpdateProduct;
    return ProductFormNotifier(
      product: product,
      onSubmmitCallback: createUpdateProductCallback,
    );
  },
);

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmmitCallback;

  ProductFormNotifier({this.onSubmmitCallback, required Product product})
      : super(ProductFormState(
          id: product.id == 'new' ? null : product.id,
          title: Title.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price),
          inStock: Stock.dirty(product.stock),
          sizes: product.sizes,
          gender: product.gender,
          description: product.description,
          tags: product.tags.join(','),
          images: product.images,
        ));

  Future<bool> onFormSubmmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;
    if (onSubmmitCallback == null) return false;

    final productLike = {
      // "id": state.id == 'new' ? null : state.id,
      "id": state.id,
      "title": state.title.value,
      "price": state.price.value,
      "description": state.description,
      "slug": state.slug.value,
      "stock": state.inStock.value,
      "sizes": state.sizes,
      "gender": state.gender,
      //*Divide una cadena en arreglo en base al caracter.
      "tags": state.tags.split(','),
      "images": state.images
          .map(
            (image) =>
                image.replaceAll('${Environment.apiUrl}/files/product/', ''),
          )
          .toList(),
    };

    try {
      return await onSubmmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.inStock.value),
    ]));
  }

  //! Métodos de validaciones de formularios.
  void onTitleChanged(String value) {
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onPriceChanged(double? value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onStockChanged(int? value) {
    state = state.copyWith(
      inStock: Stock.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(value),
      ]),
    );
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(
      sizes: sizes,
    );
  }
  // void onSizeChanged(List<String> sizes, String size) {

  //   if(state.sizes.contains(size)){
  //     state = state.copyWith(
  //       sizes: state.sizes..remove(size)
  //     );
  //   }

  //   state = state.copyWith(
  //     sizes: [...state.sizes, ...sizes],
  //   );
  // }

  //!Métodos para obtener la data de los demas campos.
  void onGenderChanged(String gender) {
    state = state.copyWith(
      gender: gender,
    );
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(
      description: description,
    );
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(
      tags: tags,
    );
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState(
      {this.isFormValid = false,
      this.id,
      this.title = const Title.dirty(''),
      this.slug = const Slug.dirty(''),
      this.price = const Price.dirty(0),
      this.sizes = const [],
      this.gender = 'men',
      this.inStock = const Stock.dirty(0),
      this.description = '',
      this.tags = '',
      this.images = const []});

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) {
    return ProductFormState(
      isFormValid: isFormValid ?? this.isFormValid,
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      sizes: sizes ?? this.sizes,
      gender: gender ?? this.gender,
      inStock: inStock ?? this.inStock,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      images: images ?? this.images,
    );
  }
}
