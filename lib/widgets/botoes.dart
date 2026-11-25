import 'package:flutter/material.dart';

class Botoes extends StatelessWidget {
  final String texto;
  final IconData icone;
  final void Function() onPressed;
  //parametros do construtor

  const Botoes(this.texto, this.icone, {super.key, required this.onPressed});
  //construtor da classe

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icone),
        label: Text(texto, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
