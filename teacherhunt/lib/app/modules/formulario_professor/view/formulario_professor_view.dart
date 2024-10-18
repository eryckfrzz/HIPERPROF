import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teacherhunt/app/components/hp_elevated_button.dart';
import 'package:teacherhunt/app/components/hp_outlined_button.dart';
import 'package:teacherhunt/app/components/hp_text_area.dart';
import 'package:teacherhunt/app/components/hp_text_form_field.dart';
import 'package:teacherhunt/app/components/ht_text_title.dart';
import 'package:teacherhunt/app/mixins/form_validate_mixins.dart';
import 'package:teacherhunt/app/modules/formulario_professor/components/foto_floatactionbutton.dart';
import 'package:teacherhunt/app/modules/formulario_professor/controller/formulario_controller.dart';
import 'package:teacherhunt/data/models/professor_model.dart';

class FormularioProfessorView extends StatefulWidget {
  final Professor? professor;
  const FormularioProfessorView({super.key, required this.professor});

  @override
  State<FormularioProfessorView> createState() =>
      _FormularioProfessorViewState();
}

class _FormularioProfessorViewState extends State<FormularioProfessorView>
    with FormValidateMixin {
  final key = GlobalKey<FormState>();

  late final controller = FormularioController(
    isValidForm: () => key.currentState?.validate() ?? false,
    onOpenSnackbar: (erroMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erroMessage),
          action: SnackBarAction(label: 'Ok', onPressed: () {}),
          duration: const Duration(seconds: 30),
        ),
      );
    },
    onNavigator: (route, novoProfessor) {
      Navigator.pushNamedAndRemoveUntil(
          context, route, arguments: novoProfessor, (route) => false);
    },
    openDialog: (controller) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 210,
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  const HPTextTitle(
                    text: 'Tem certeza que deseja apagar sua conta ?',
                    size: HPSizeTitle.small,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Ao apagar sua conta, também será excluido todo o histórico de alunos ',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Não apagar'),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.error),
                          ),
                          onPressed: controller.apagarConta,
                          child: const Text('Apagar'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );

  @override
  void dispose() {
    controller.nomeController.dispose();
    controller.idadeController.dispose();
    controller.valorAulaController.dispose();
    controller.emailController.dispose();
    controller.senhaController.dispose();
    controller.confirmarSenhaController.dispose();
    controller.descricaoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.inicialProfessor(widget.professor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
      ),
      floatingActionButton: Visibility(
        visible: widget.professor != null,
        child: FloatingActionButton(
          onPressed: controller.openCam,
          shape: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, snapshot) {
                return FotoFloatActionButton(img: controller.image);
              }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 60, right: 60),
            child: Form(
              key: key,
              child: Column(
                children: [
                  const HPTextTitle(
                    text: 'Dados de cadastro',
                    size: HPSizeTitle.normal,
                  ),
                  HPTextFormField(
                    validator: validateFormRequered,
                    controller: controller.nomeController,
                    label: 'Nome',
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  HPTextFormField(
                    validator: validateFormNumber,
                    controller: controller.idadeController,
                    label: 'Idade',
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  HPTextFormField(
                    validator: validateFormRequered,
                    controller: controller.valorAulaController as TextEditingController,
                    label: 'Valor da aula',
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  HPTextFormField(
                    validator: validateFormEmail,
                    controller: controller.emailController,
                    label: 'Email',
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  HPTextFormField(
                    validator: controller.validSenha,
                    controller: controller.senhaController,
                    obscureText: true,
                    label: 'Senha',
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  HPTextFormField(
                    validator: controller.validSenha,
                    controller: controller.confirmarSenhaController,
                    obscureText: true,
                    label: 'Confirmar Senha',
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  HPTextArea(
                    label: 'Descrição',
                    controller: controller.descricaoController,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    validator: validateFormRequered,
                  ),
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return HPElevatedButton(
                        padding: const EdgeInsets.only(
                            top: 50, bottom: 20, right: 60, left: 60),
                        onPressed: controller.salvarConta,
                        child: Visibility(
                          visible: !controller.load,
                          replacement: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          child: Visibility(
                            visible: widget.professor == null,
                            replacement: const Text('Editar Conta'),
                            child: const Text('Cadastrar conta'),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.professor != null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const HPTextTitle(
                          text:
                              'Você pode apagar sua conta, desse modo não será mais exibido na plataforma',
                          size: HPSizeTitle.small,
                        ),
                        HPOutlinedButton(
                          onPressed: controller.openModal,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all(
                                  Theme.of(context).colorScheme.error)),
                          child: const Text('Apagar minha conta'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
