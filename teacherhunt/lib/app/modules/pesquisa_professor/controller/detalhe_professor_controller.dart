import 'package:flutter/material.dart';
import 'package:teacherhunt/app/mixins/format_data.dart';
import 'package:teacherhunt/app/modules/pesquisa_professor/service/pesquisa_professor_service.dart';
import 'package:teacherhunt/data/models/aluno_model.dart';

class DetalheProfessorController extends ChangeNotifier with FormatData {
  final Function(DetalheProfessorController) onOpenModalForm;
  final bool Function() onValidForm;
  final Future<DateTime?> Function() onOpenDatePicker;
  final Future<TimeOfDay?> Function() onOpenTimePicker;
  final VoidCallback onNavigatorPop;
  final Function() onOpenSnacBar;

  var load = false;
  var messageErro = '';
  var _data = '';

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final dataController = TextEditingController();

  final PesquisaProfessorService _service = PesquisaProfessorService();

  DetalheProfessorController({
    required this.onOpenModalForm,
    required this.onValidForm,
    required this.onOpenDatePicker,
    required this.onOpenTimePicker,
    required this.onOpenSnacBar,
    required this.onNavigatorPop,
  });

  void contratarProfessor() {
    onOpenModalForm(this);
  }

  Future<void> selecionarData() async {
    final dateTime = await onOpenDatePicker();
    final timeOfDay = await onOpenTimePicker();
    dataController.text =
        formatDataComHoraBr(dateTime: dateTime!, timeOfDay: timeOfDay!);

    _data = formatDataComHoraIso(dateTime: dateTime, timeOfDay: timeOfDay);
  }

  Future<void> contratar({required int professorId}) async {
    final isValid = onValidForm();

    if (isValid && !load) {
      load = true;
      messageErro = '';
      notifyListeners();
      try {
        final aluno = Aluno(
          nome: nomeController.text,
          email: emailController.text,
          data: _data,
        );

        await _service.salvarAluno(aluno: aluno, professorId: professorId);
        onNavigatorPop();
        onOpenSnacBar();
      } catch (e) {
        messageErro = e.toString();
      } finally {
        load = false;
        notifyListeners();
      }
    }
  }
}
