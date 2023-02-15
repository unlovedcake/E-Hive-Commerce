import 'dart:convert';

import 'package:adopt_a_pet/pages/Server/APi-Response.dart';
import 'package:http/http.dart' as http;
import '../../model/product-model.dart';
import 'Server.dart';

class NetworkDataSource implements DataSource {
  @override
  Future<ApiResponse> fetchData() async {
    ApiResponse apiResponse = ApiResponse();
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final jsonData = json.decode((response.body));

      ProductListModel? decodedData = ProductListModel.fromMap(jsonData);
      apiResponse.productList = decodedData.productData!;
    } else {
      apiResponse.error = jsonDecode(response.body)['message'];
      throw Exception('Failed to load data');
    }

    return apiResponse;
  }
}
