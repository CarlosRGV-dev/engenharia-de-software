import 'package:flutter/material.dart';

//Mostra um aviso rápido na parte de baixo da tela
void mostrarAviso(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
}

//Pergunta "Sim / Não" antes de excluir. Devolve true se confirmou.
Future<bool> confirmar(BuildContext context, String texto) async {
  final resposta = await showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: const Text('Confirmar'),
        content: Text(texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sim'),
          ),
        ],
      );
    },
  );
  return resposta ?? false;
}
