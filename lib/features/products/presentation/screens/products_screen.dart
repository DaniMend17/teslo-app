import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';
import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {
          context.push('/product/new');
        },
      ),
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  ProductsViewState createState() => ProductsViewState();
}

class ProductsViewState extends ConsumerState {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(
      () {
        if ((scrollController.position.pixels + 400) >=
            scrollController.position.maxScrollExtent) {
          //*En el caso del infinite scroll si hago el loadNextPage a pesar de hacerlo al momento de instanciar el notifier.
          //*Debido a que de lo contrario cada que se dispare el listener no se obtendrían nuevos productos.
          //*De igual manera debido a validaciones en el método load estas evitan que se carguen peliculas de mas al momento
          //*de instanciar el notofier.
          ref.read(productsProvider.notifier).loadNextPage();
        }
      },
    );

    // ref.read(productsProvider.notifier).loadNextPage();
    //! No vuelvo a hacer el .loadNextPage debido a que el constructor del notifier lo hace al
    //! crear la instancia.
    // ref.read(productsProvider.notifier);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          final product = productsState.products[index];
          return GestureDetector(
              onTap: () {
                context.push('/product/${product.id}');
              },
              child: ProductsCard(product: product));
        },
      ),
    );
  }
}
