import 'package:flutter/material.dart';
import 'package:teacherhunt/app/components/hp_elevated_button.dart';
import 'package:teacherhunt/app/components/hp_text_form_field.dart';
import 'package:teacherhunt/app/components/ht_text_title.dart';
import 'package:teacherhunt/app/mixins/form_validate_mixins.dart';
import 'package:teacherhunt/app/modules/pesquisa_professor/components/card_lista_professor.dart';
import 'package:teacherhunt/app/modules/pesquisa_professor/controller/detalhe_professor_controller.dart';
import 'package:teacherhunt/data/models/professor_model.dart';

class DetalheProfessorView extends StatelessWidget with FormValidateMixin {
  DetalheProfessorView({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final professor = ModalRoute.of(context)!.settings.arguments as Professor;
    final controller = DetalheProfessorController(
        onOpenModalForm: (controller) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  height: 400,
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                  child: SingleChildScrollView(
                    child: Form(
                      key: key,
                      child: Column(
                        children: [
                          const HPTextTitle(
                              text: 'Preencha suas informações',
                              size: HPSizeTitle.small),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Em breve o professor entratá em contato',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          HPTextFormField(
                            controller: controller.nomeController,
                            validator: validateFormRequered,
                            label: 'Seu nome',
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          HPTextFormField(
                            controller: controller.emailController,
                            validator: validateFormEmail,
                            label: 'Seu Email',
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          HPTextFormField(
                            onTap: controller.selecionarData,
                            keyboardType: TextInputType.none,
                            controller: controller.dataController,
                            validator: validateFormRequered,
                            label: 'Hora e data da aula',
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              return Visibility(
                                visible: controller.messageErro != '',
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    controller.messageErro,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.error,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              return HPElevatedButton(
                                onPressed: () => controller.contratar(
                                    professorId: professor.id!),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Visibility(
                                  visible: !controller.load,
                                  replacement: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  child: const Text('Contratar'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        onValidForm: () => key.currentState?.validate() ?? false,
        onOpenDatePicker: () async {
          return await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019, 1),
            lastDate: DateTime(2030),
          );
        },
        onOpenTimePicker: () async {
          return showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 0, minute: 0),
          );
        },
        onOpenSnacBar: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'O professor entrará em contato com você em breve'),
              action: SnackBarAction(
                label: 'Ok',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              duration: const Duration(seconds: 30),
            ),
          );
        },
        onNavigatorPop: () {
          Navigator.pop(context);
        });

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 40),
          child: Column(
            children: [
              CardProfessor(
                professor: professor,
                maxLines: 30,
              ),
              HPElevatedButton(
                onPressed: controller.contratarProfessor,
                child: Text('Contratar ${professor.nome}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
