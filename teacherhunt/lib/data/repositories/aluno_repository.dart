import 'package:http/http.dart' as http;
import 'package:teacherhunt/data/provider/client_api.dart';

class AlunoRepository {
  final ApiClient _apiClient = ApiClient();

  Future<http.Response> save({required Map<String, dynamic> data}) async {
    final response = await _apiClient.post('https://127.0.0.1:8000/api/alunos', data: data); 
    return response;
  }

  Future<http.Response> getAlunos() async {
    final response = await _apiClient.get('https://127.0.0.1:8000/api/alunos/me'); 
    return response;
  }
}
