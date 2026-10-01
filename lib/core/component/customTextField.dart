// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  TextEditingController? controller;
  Widget? label;
  void Function(String)? onChange;
  String? Function(String?)? validator;

  CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.onChange,
    this.validator,
    isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator,
        onChanged: onChange,
      ),
    );
  }
}
