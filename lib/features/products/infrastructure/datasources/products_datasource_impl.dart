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



  Future<List<String>> _uploadPhotos(List<String> photos)async {
    //* Si no hay fotos nuevas photosToUpload se queda vacio [].
    final photosToUpload = photos.where((photo) => photo.contains('/'),).toList();
    final photosToIgnore = photos.where((photo) => !photo.contains('/'),).toList();

    //* Si photosToUpload es [] entonces uploadJob  es Future<[]>.
    final List<Future<String>> uploadJob = photosToUpload.map(
      (photo) => _uploadFile(photo),
    ).toList();

    //* Si uploadJob es [] entonces espera la resolución de su future la cual será []. 
    final newImages = await Future.wait(uploadJob);

    //
    return [...photosToIgnore, ...newImages];
  }

  Future<String> _uploadFile(String path) async {
    try {

      //* De la url de la imagen guardada de manera local en el dispositivo obtengo unicamente el nombre del archivo.
      final String fileName = path.split('/').last;

      //* Me rotorna un mapa con la llave file la cual contiene un archivo con el nombre de la imagen tomada con la camara o sacada de la galería.
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName)
      });
      
      //* Subo la imagen a la apirest.
      final response = await dio.post('/files/product', data: data);

      //*Retorno el nombre de la imagen ya guardada que me devuelve la petición a la api.
      return response.data['image'];

    } catch (e) {
      throw Exception();
    }
  } 



  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    final String? productId = productLike['id'];
    final String method = (productId == null) ? 'POST' : 'PATCH';
    final String url = (productId == null) ? '/products' : '/products/$productId';

    productLike.remove('id');
    productLike['images'] = await _uploadPhotos(productLike['images']);

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
