import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';

import '../../domain/domain.dart';
import '../infrastructure.dart';

class ProductsDatasourceImpl implements ProductsDatasource {
  //*la propiedad es late debido a que para su configuración necesitamos el token de acceso.
  late Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    final String? productId = productLike['id'];
    final String method = (productId == null) ? 'POST' : 'PATCH';
    final String url = (productId == null) ? '/products' : '/products/$productId';

    productLike.remove('id');

    try {
      final response = await dio.request(url,
          data: productLike,
          options: Options(
            method: method,
          ));

      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 400) throw ProductNotFounded();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];
    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    // TODO: implement searchProductsByTerm
    throw UnimplementedError();
  }
}
