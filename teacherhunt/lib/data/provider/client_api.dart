import 'package:http/http.dart' as http;
import 'package:teacherhunt/data/provider/rest_interface.dart';


class ApiClient implements Rest {
  
  @override
  Future<http.Response> delete(String path) async {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> get(String path, {Map<String, dynamic>? query}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> post(String path, {required data}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> put(String path, {required data}) {
    throw UnimplementedError();
  }
}

  