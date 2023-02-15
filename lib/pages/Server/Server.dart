import 'package:adopt_a_pet/pages/Server/APi-Response.dart';

abstract class DataSource {
  Future<ApiResponse> fetchData();
}
