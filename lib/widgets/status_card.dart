import 'package:flutter/material.dart';
import 'package:gestao_frota/model/caminhao.dart';

//Cor de cada status do caminhão
MaterialColor corDoStatus(String status) {
  if (status == Caminhao.disponivel) return Colors.green;
  if (status == Caminhao.emUso) return Colors.blue;
  if (status == Caminhao.quebrado) return Colors.red;
  return Colors.orange; //A emplacar
}

//Ícone de cada status do caminhão
IconData iconeDoStatus(String status) {
  if (status == Caminhao.disponivel) return Icons.check_circle;
  if (status == Caminhao.emUso) return Icons.local_shipping;
  if (status == Caminhao.quebrado) return Icons.build;
  return Icons.assignment; //A emplacar
}

//Cartão do painel com um contador (RF09)
class StatusCard extends StatelessWidget {
  final String titulo;
  final int quantidade;
  final MaterialColor cor;
  final IconData icone;
  //parametros do construtor

  const StatusCard(this.titulo, this.quantidade, this.cor, this.icone, {super.key});
  //construtor da classe

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cor.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: cor.shade700, size: 30),
            const SizedBox(height: 8),
            Text(
              '$quantidade',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: cor.shade800),
            ),
            Text(titulo, style: TextStyle(color: cor.shade800)),
          ],
        ),
      ),
    );
  }
}

//Etiqueta colorida com o status do caminhão
class EtiquetaStatus extends StatelessWidget {
  final String status;
  //parametros do construtor

  const EtiquetaStatus(this.status, {super.key});
  //construtor da classe

  @override
  Widget build(BuildContext context) {
    final cor = corDoStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: cor.shade800, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
