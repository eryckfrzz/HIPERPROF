import 'package:flutter/material.dart';
import 'package:teacherhunt/app/modules/formulario_professor/view/formulario_professor_view.dart';
import 'package:teacherhunt/app/modules/home_professor/view/home_professor_view.dart';
import 'package:teacherhunt/app/modules/inicial/views/inicial_view.dart';
import 'package:teacherhunt/app/modules/login/views/login_view.dart';
import 'package:teacherhunt/app/modules/pesquisa_professor/views/detalhe_professor_view.dart';
import 'package:teacherhunt/app/modules/pesquisa_professor/views/pesquisa_professor_view.dart';
import 'package:teacherhunt/data/models/professor_model.dart';
import 'package:teacherhunt/routes.dart';
import 'package:teacherhunt/theme/theme_data.dart';

void main() {
  GetStorage.init();
  runApp(const MyApp());
}

class GetStorage {
  static void init() {}

  write(String s, Map<String, dynamic> json) {}

  read(String s) {}

  void remove(String s) {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CustomThemeData.ligth(),
      darkTheme: CustomThemeData.dark(),
      themeMode: ThemeMode.system,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == Routes.PESQUISA_PROFESSOR) {
          final searchProfessor = routeSettings.arguments as String;
          return MaterialPageRoute(
              builder: (context) => PesquisaProfessorView(
                    searchProfessor: searchProfessor,
                  ));
        }

        if (routeSettings.name == Routes.FORMULARIO_PROFESSOR) {
          final professor = routeSettings.arguments as Professor?;
          return MaterialPageRoute(
              builder: (context) => FormularioProfessorView(
                    professor: professor,
                  ));
        }
        return null;
      },
      routes: {
        Routes.INCIAL: (context) => const InicialView(),
        Routes.DETALHE_PROFESSOR: (context) => DetalheProfessorView(),
        Routes.LOGIN: (context) => const LoginView(),
        Routes.HOME_PROFESSOR: (context) => const HomeProfessorView(),
      },
    );
  }
}
