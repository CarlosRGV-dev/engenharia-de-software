import 'package:flutter/material.dart';

class Textos extends StatelessWidget {
  final String meuTexto;
  final Color cores;
  final double tamanho;
  //parametros do construtor

  const Textos(this.meuTexto, this.cores, {super.key, this.tamanho = 22});
  //construtor da classe

  @override
  Widget build(BuildContext context) {
    return Text(
      meuTexto,
      style: TextStyle(
        color: cores,
        fontSize: tamanho,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
