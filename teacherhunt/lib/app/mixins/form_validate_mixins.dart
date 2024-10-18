mixin FormValidateMixin {
  final validateFormRequered = Validatorless.required('Campo é obrigatório');

  final validateFormEmail = Validatorless.multiple([
    Validatorless.required('Campo é obrigatório'),
    Validatorless.email('Email inválido')
  ]);

  final validateFormNumber = Validatorless.multiple([
    Validatorless.required('Campo é obrigatório'),
    Validatorless.number('Somente números')
  ]);
}

class Validatorless {
  static multiple(List<dynamic> list) {}
  
  static required(String s) {}
  
  static number(String s) {}
  
  static email(String s) {}
}
