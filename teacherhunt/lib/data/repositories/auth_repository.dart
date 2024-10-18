import 'package:http/http.dart' as http;
import 'package:teacherhunt/data/provider/client_api.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<http.Response> postLogin(Map<String, dynamic> data) async {
    final response = await _apiClient.post('https://127.0.0.1:8000/api/auth/login', data: data);
    return response;
  }

  Future<http.Response> logout() async {
    final response = await _apiClient.delete('https://127.0.0.1:8000/api/auth/logout');
    return response;
  }
}
