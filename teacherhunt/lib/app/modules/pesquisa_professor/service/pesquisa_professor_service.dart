import 'dart:convert';
import 'dart:developer';

import 'package:teacherhunt/data/models/aluno_model.dart';
import 'package:teacherhunt/data/models/professor_model.dart';
import 'package:teacherhunt/data/repositories/aluno_repository.dart';
import 'package:teacherhunt/data/repositories/professor_repository.dart';

class PesquisaProfessorService {
  final ProfessorRepository _professorRepository = ProfessorRepository();
  final AlunoRepository _alunoRepository = AlunoRepository();

  Future<List<Professor>> getAllProfessores(String? search) async {
    try {
      final response = await _professorRepository.getAll(search);

      if (response.statusCode == 200) {
        final professores = (json.decode(response.body) as List)
            .map((json) => Professor.fromJson(json))
            .toList();
        return professores;
      } else {
        throw "Erro ao buscar professores";
      }
    } catch (erro, s) {
      log("Erro ao buscar professores", error: erro, stackTrace: s);
      throw "Erro ao buscar professores";
    }
  }

  Future<void> salvarAluno(
      {required Aluno aluno, required int professorId}) async {
    try {
      final response = await _alunoRepository.save(
          data: aluno.toJson());

      if (response.statusCode != 200) {
        throw "Erro ao salvar aluno";
      }
    } catch (erro, s) {
      log("Erro ao salvar aluno", error: erro, stackTrace: s);
      throw "Erro ao salvar aluno";
    }
  }
}
