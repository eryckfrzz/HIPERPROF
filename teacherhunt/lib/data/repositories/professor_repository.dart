import 'package:http/http.dart' as http;
import 'package:teacherhunt/data/provider/client_api.dart';
import 'package:teacherhunt/data/storage/auth.dart';

class ProfessorRepository {
  final ApiClient _apiClient = ApiClient();

  Future<http.Response> getAll(String? search) async {
    final response = await _apiClient.get('https://127.0.0.1:8000/api/professores', query: {'q': search});
    return response;
  }

  Future<http.Response> save({required Map<String, dynamic> data, int? id}) async {
    if (id == null) {
      return await _apiClient.post('/professores', data: data);
    }
    return await _apiClient.put('/professores', data: data);
  }

  Future<http.Response> saveFotoProfessor({required image, required int professorId}) async {
    final responseProfessor = Storage().getToken();

    final header = {
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
      "Authorization": 'Bearer ${responseProfessor?.token}',
    };

    final request = http.MultipartRequest('POST', Uri.parse('https://127.0.0.1:8000/api/professores/foto')) 
      ..headers.addAll(header)
      ..files.add(await http.MultipartFile.fromPath('image', image));

    final response = await http.Response.fromStream(await request.send());
    return response;
  }

  Future<http.Response> delete() async {
    final response = await _apiClient.delete('https://127.0.0.1:8000/api/professores');
    return response;
  }
}
