import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String rotulo;
  final String label;
  final TextEditingController controller;
  final TextInputType teclado;
  //parametros do construtor

  const Input(this.rotulo, this.label,
      {super.key, required this.controller, this.teclado = TextInputType.text});
  //construtor da classe

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: teclado,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          hintText: rotulo,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
