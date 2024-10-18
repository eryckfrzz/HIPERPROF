import 'package:flutter/cupertino.dart';
import 'package:teacherhunt/app/mixins/format_data.dart';
import 'package:teacherhunt/app/modules/home_professor/models/item_model.dart';
import 'package:teacherhunt/app/modules/home_professor/service/home_professor_service.dart';
import 'package:teacherhunt/data/models/aluno_model.dart';
import 'package:teacherhunt/routes.dart';

class HomeProfessorController extends ChangeNotifier with FormatData {
  final HomeProfessorService _service = HomeProfessorService();
  var itens = const <ItemModel>[];

  final void Function(String) onNavigatePaginaInicial;
  final void Function(String) openSnackbar;
  final void Function(String) onNavigateEditar;

  HomeProfessorController(
      {required this.onNavigatePaginaInicial,
      required this.openSnackbar,
      required this.onNavigateEditar});

  void editarProfessor() {
    onNavigateEditar(Routes.FORMULARIO_PROFESSOR);
  }

  void acessarPaginaPrincipal() {
    onNavigatePaginaInicial(Routes.INCIAL);
  }

  Future<void> logout() async {
    try {
      await _service.logout();
      onNavigatePaginaInicial(Routes.INCIAL);
    } catch (e) {
      openSnackbar(e.toString());
    }
  }

  void expansionCallback(int index, bool isExpanded) {
    itens[index].isExpanded = !isExpanded;
    notifyListeners();
  }

  Future<List<Aluno>> getAllAlunos() async {
    try {
      final alunos = await _service.getAlunos();
      itens = alunos
          .map((aluno) => ItemModel(
                nome: aluno.nome,
                email: aluno.email,
                data: formatarDataStringParaBr(aluno.data),
              ))
          .toList();

      return alunos;
    } catch (e) {
      rethrow;
    }
  }
  
}
