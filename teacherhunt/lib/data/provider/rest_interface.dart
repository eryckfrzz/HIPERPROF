import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teacherhunt/data/storage/auth.dart';

abstract class Rest {
  Future<http.Response> get(String path, {Map<String, dynamic>? query});

  Future<http.Response> post(String path, {required data});

  Future<http.Response> delete(String path);

  Future<http.Response> put(String path, {required data});
}

class RestImpl implements Rest {
  final String baseUrl;
  final Storage storage = Storage();

  RestImpl(this.baseUrl);

  @override
  Future<http.Response> get(String path, {Map<String, dynamic>? query}) async {
    final uri = Uri.parse(path).replace(queryParameters: query);
    final response = await http.get(uri);
    return response;
  }

  @override
  Future<http.Response> post(String path, {required data}) async {
    final uri = Uri.parse(path);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return response;
  }

  @override
  Future<http.Response> delete(String path) async {
    final token = storage.getToken()?.token;
    final uri = Uri.parse(path);
    final response = await http.delete(uri, headers: {'Authorization': 'Bearer $token'});

    return response;
  }

  @override
  Future<http.Response> put(String path, {required data}) async {
    final token = storage.getToken()?.token;
    final uri = Uri.parse(path);
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: json.encode(data),
    );
    return response;
  }
}
