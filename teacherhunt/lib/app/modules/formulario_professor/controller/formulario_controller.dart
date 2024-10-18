import 'package:flutter/cupertino.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teacherhunt/app/modules/formulario_professor/model/cadastro_professor.dart';
import 'package:teacherhunt/app/modules/formulario_professor/service/formulario_service.dart';
import 'package:teacherhunt/data/models/professor_model.dart';
import 'package:teacherhunt/routes.dart';

class FormularioController extends ChangeNotifier {
  final FormularioService _service = FormularioService();
  final ImagePicker _imagePicker = ImagePicker();

  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final emailController = TextEditingController();
  final idadeController = TextEditingController();

  final valorAulaController = MoneyMaskedTextController(
      leftSymbol: 'R\$', decimalSeparator: '.', thousandSeparator: ',');

  final bool Function() isValidForm;
  final Function(String) onOpenSnackbar;
  final Function(String, Professor?) onNavigator;
  final void Function(FormularioController) openDialog;

  String? image;
  Professor? _professor;
  var load = false;

  FormularioController({
    required this.isValidForm,
    required this.onOpenSnackbar,
    required this.onNavigator,
    required this.openDialog,
  });

  Future<void> salvarConta() async {
    final isValid = isValidForm();
    if (isValid && !load) {
      load = true;
      notifyListeners();
      try {
        final professor = CadastroProfessor(
          nome: nomeController.text,
          descricao: descricaoController.text,
          email: emailController.text,
          valorAula: valorAulaController.numberValue,
          idade: int.parse(idadeController.text),
          password: senhaController.text,
          passwordConfirm: confirmarSenhaController.text,
          fotoPerfil: _professor?.fotoPerfil,
          id: _professor?.id,
        );
        final Professor novoProfessor;

        if (_professor?.id != null) {
          novoProfessor = await _service.editarProfessor(professor);
        } else {
          novoProfessor = await _service.cadastrarProfessor(professor);
        }

        onNavigator(Routes.HOME_PROFESSOR, novoProfessor);
      } catch (erro) {
        onOpenSnackbar(erro.toString());
      } finally {
        load = false;
        notifyListeners();
      }
    }
  }

  Future<void> openCam() async {
    if (!load) {
      final XFile? xFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 30,
      );
      if (xFile != null) {
        try {
          load = true;
          notifyListeners();
          final novoImagem = await _service.salvarImagemProfessor(
            path: xFile,
            professorId: _professor!.id!,
          );

          image = novoImagem;
        } catch (e) {
          onOpenSnackbar(e.toString());
        } finally {
          load = false;
          notifyListeners();
        }
      }
    }
  }

  String? validSenha(String? value) {
    if (value?.isEmpty ?? false) {
      return 'Campos obrigatórios';
    }

    if (senhaController.text != confirmarSenhaController.text) {
      return 'Valores diferentes';
    }

    if (senhaController.text.length <= 5) {
      return 'minimo de 6 caracteres';
    }

    return null;
  }

  void inicialProfessor(Professor? professor) {
    if (professor != null) {
      _professor = professor;
      nomeController.text = professor.nome;
      idadeController.text = professor.idade.toString();
      valorAulaController.updateValue(professor.valorAula);
      emailController.text = professor.email;
      descricaoController.text = professor.descricao;
      image = professor.fotoPerfil;
    }
  }

  void openModal() {
    openDialog(this);
  }

  Future<void> apagarConta() async {
    if (!load) {
      try {
        load = true;
        notifyListeners();
        await _service.deletarProfessor();
        onNavigator(Routes.INCIAL, null);
      } catch (e) {
        onOpenSnackbar(e.toString());
      } finally {
        load = false;
        notifyListeners();
      }
    }
  }
}




