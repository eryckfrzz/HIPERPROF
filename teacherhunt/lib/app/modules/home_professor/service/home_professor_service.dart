import 'dart:convert';
import 'dart:developer';

import 'package:teacherhunt/data/models/aluno_model.dart';
import 'package:teacherhunt/data/repositories/aluno_repository.dart';
import 'package:teacherhunt/data/repositories/auth_repository.dart';
import 'package:teacherhunt/data/storage/auth.dart';

class HomeProfessorService {
  final AlunoRepository _alunoRepository = AlunoRepository();
  final AuthRepository _authRepository = AuthRepository();
  final Storage _storage = Storage();

  Future<List<Aluno>> getAlunos() async {
    try {
      final response = await _alunoRepository.getAlunos();
      if (response.statusCode == 200) {
        return (json.decode(response.body) as List)
            .map((json) => Aluno.fromJson(json))
            .toList();
      } else {
        throw 'ERRO AO BUSCAR ALUNOS';
      }
    } catch (erro, s) {
      log('ERRO AO BUSCAR ALUNOS', error: erro, stackTrace: s);
      throw 'ERRO AO BUSCAR ALUNOS';
    }
  }

  Future<void> logout() async {
    try {
      final response = await _authRepository.logout();
      if (response.statusCode == 200) {
        _storage.clearToken();
      } else {
        throw 'ERRO AO FAZER LOGOUT';
      }
    } catch (erro, s) {
      log('ERRO AO FAZER LOGOUT', error: erro, stackTrace: s);
      throw 'ERRO AO FAZER LOGOUT';
    }
  }
}
