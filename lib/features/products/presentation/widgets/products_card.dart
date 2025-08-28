import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class ProductsCard extends StatelessWidget {
  final Product product;
  const ProductsCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageViewer(images: product.images),
        Text(product.title, textAlign: TextAlign.center,),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;
  const _ImageViewer({required this.images});

  @override
  Widget build(BuildContext context) {
    //* Evaluamos si es que existen imagenes.
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: 250,
        ),
      );
    }
    //*Si existen imagenes.
    return ClipRRect(
      child: FadeInImage(
          fit: BoxFit.cover,
          height: 250,
          fadeOutDuration: const Duration(milliseconds: 100),
          fadeInDuration: const Duration(milliseconds: 200),
          image: NetworkImage(images.first),
          placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),

      ),
    );
  }
}
