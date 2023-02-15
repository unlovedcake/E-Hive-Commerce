import 'package:adopt_a_pet/pages/Server/APi-Response.dart';

import 'Server.dart';

class Repository {
  final DataSource dataSource;

  Repository({required this.dataSource});

  Future<ApiResponse> fetchData() async {
    return dataSource.fetchData();
  }
}
