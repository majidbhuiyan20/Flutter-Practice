class Urls {
  static const String baseUrl = 'http://35.73.30.144:2008/api/v1';
  static const String createProduct = '$baseUrl/CreateProduct';
  static const String getProductUrl = '$baseUrl/ReadProduct';

  static String deleteProductUrl(String id) => '$baseUrl/DeleteProduct/$id';

  static String updateProductUrl(String id) => '$baseUrl/UpdateProduct/$id';

}