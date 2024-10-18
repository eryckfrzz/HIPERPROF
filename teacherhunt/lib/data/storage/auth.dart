import 'package:teacherhunt/data/models/response_professor.dart';
import 'package:teacherhunt/main.dart';

class Storage {
  final _getStorage = GetStorage();

  Future<void> saveToken(ResponseProfessor responseProfessor) async {
    await _getStorage.write('auth', responseProfessor.toJson());
  }

  ResponseProfessor? getToken() {
    final res = _getStorage.read('auth');

    if (res != null) {
      return ResponseProfessor.fromJson(res);
    }
    return null;
  }

  void clearToken() {
    _getStorage.remove('auth');
  }
}
