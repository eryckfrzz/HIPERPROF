import 'package:flutter/cupertino.dart';
import 'package:teacherhunt/data/storage/auth.dart';
import 'package:teacherhunt/routes.dart';

class InicialController {
  final bool Function() isValidForm;
  final Function(String route, Object? search) onNavigatorProfessor;
  final searchController = TextEditingController();

  InicialController(
      {required this.isValidForm, required this.onNavigatorProfessor});

  String? validateSarch(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Digite o que deseja aprender';
    }

    return null;
  }

  void buscarProfessor() {
    final isValid = isValidForm();

    if (isValid) {
      onNavigatorProfessor(Routes.PESQUISA_PROFESSOR, searchController.text);
    }
  }

  void sejaProfessor() {
    onNavigatorProfessor(Routes.FORMULARIO_PROFESSOR, null);
  }

  void consultarAula() {
    final professorResponse = Storage().getToken();

    if (professorResponse != null) {
      onNavigatorProfessor(Routes.HOME_PROFESSOR, professorResponse.professor!);
    } else {
      onNavigatorProfessor(Routes.LOGIN, null);
    }
  }
}
