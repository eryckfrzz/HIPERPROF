import 'package:flutter/material.dart';
import 'package:teacherhunt/app/components/hp_text_form_field.dart';

class HPTextArea extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? padding;
  final String? Function(String?)? validator;
  const HPTextArea({
    super.key,
    this.label,
    this.controller,
    this.padding,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return HPTextFormField(
      label: label,
      controller: controller,
      padding: padding,
      validator: validator,
      maxLines: 4,
      hintMaxLines: 3,
    );
  }
}
