import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:teacherhunt/app/modules/login/models/login_model.dart';
import 'package:teacherhunt/data/models/professor_model.dart';
import 'package:teacherhunt/data/models/response_professor.dart';
import 'package:teacherhunt/data/repositories/auth_repository.dart';
import 'package:teacherhunt/data/storage/auth.dart';

class LoginService {
  final AuthRepository _authRepository = AuthRepository();

  final Storage _storage = Storage();

  Future<Professor> login(LoginModel loginModel) async {
    try {
      final response = await _authRepository.postLogin(loginModel.toJson());
      if (response.statusCode == 200) {
        final responseModel = ResponseProfessor.fromJson(json.decode(response.body));
        _storage.saveToken(responseModel);
        return responseModel.professor!;
      } else {
        throw 'Erro ao fazer login';
      }
    } catch (erro, s) {
      log('ERRO AO FAZER LOGIN', error: erro, stackTrace: s);
      if (erro is http.ClientException) {
        throw erro.message;
      }
      throw 'Erro ao fazer login';
    }
  }
}
