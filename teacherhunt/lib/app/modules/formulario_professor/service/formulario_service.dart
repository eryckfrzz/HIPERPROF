import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:teacherhunt/data/models/professor_model.dart';
import 'package:teacherhunt/data/models/response_professor.dart';
import 'package:teacherhunt/data/repositories/professor_repository.dart';
import 'package:teacherhunt/data/storage/auth.dart';

class FormularioService {
  final ProfessorRepository _professorRepository = ProfessorRepository();
  final Storage _storage = Storage();

  Future<Professor> cadastrarProfessor(Professor professor) async {
    try {
      final response = await _professorRepository.save(data: professor.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final professorResponse = ResponseProfessor.fromJson(json.decode(response.body));
        _storage.saveToken(professorResponse);
        return professorResponse.professor!;
      } else {
        throw 'Erro ao salvar professor';
      }
    } catch (erro, s) {
      log('Erro ao salvar professor', error: erro, stackTrace: s);
      throw 'Erro ao salvar professor';
    }
  }

  Future<String> salvarImagemProfessor({required XFile path, required int professorId}) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('https://api.seuenderecoaqui.com/professores/$professorId/foto')); // corrigir este endereço
      request.files.add(await http.MultipartFile.fromPath('foto', path.path, filename: path.name));

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await http.Response.fromStream(response);
        final professorEditado = Professor.fromJson(json.decode(responseBody.body));
        final token = _storage.getToken()!.token;
        _storage.saveToken(ResponseProfessor(professor: professorEditado, token: token));

        return professorEditado.fotoPerfil!;
      } else {
        throw 'Erro ao salvar foto';
      }
    } catch (erro, s) {
      log('Erro ao salvar foto', error: erro, stackTrace: s);
      throw 'Erro ao salvar foto';
    }
  }

  Future<Professor> editarProfessor(Professor professor) async {
    try {
      final response = await _professorRepository.save(data: professor.toJson(), id: professor.id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final professorEditado = Professor.fromJson(json.decode(response.body));
        final token = _storage.getToken()!.token;
        _storage.saveToken(ResponseProfessor(professor: professorEditado, token: token));
        return professorEditado;
      } else {
        throw 'Erro ao editar professor';
      }
    } catch (erro, s) {
      log('Erro ao editar professor', error: erro, stackTrace: s);
      throw 'Erro ao editar professor';
    }
  }

  Future<void> deletarProfessor() async {
    try {
      final response = await _professorRepository.delete();
      if (response.statusCode == 200 || response.statusCode == 204) {
        _storage.clearToken();
      } else {
        throw 'Erro ao deletar professor';
      }
    } catch (erro, s) {
      log('Erro ao deletar professor', error: erro, stackTrace: s);
      throw 'Erro ao deletar professor';
    }
  }
}
