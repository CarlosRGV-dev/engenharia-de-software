import 'package:flutter/material.dart';
import 'package:gestao_frota/control/frota_controller.dart';
import 'package:gestao_frota/model/caminhao.dart';
import 'package:gestao_frota/telas/frota_page.dart';
import 'package:gestao_frota/telas/motoristas_page.dart';
import 'package:gestao_frota/widgets/botoes.dart';
import 'package:gestao_frota/widgets/status_card.dart';
import 'package:gestao_frota/widgets/texto.dart';

//Tela inicial: painel de sumário (RF09) e acesso às outras telas
class Home extends StatelessWidget {
  final FrotaController controller = FrotaController();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestão de Frota"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              _novaTela(context, const FrotaPage());
            },
            icon: const Icon(Icons.local_shipping),
          ),
          IconButton(
            onPressed: () {
              _novaTela(context, const MotoristasPage());
            },
            icon: const Icon(Icons.badge),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Textos("Painel da frota", Colors.blueGrey),
          const SizedBox(height: 12),

          //Atualiza sozinho quando algum caminhão muda no Firebase
          StreamBuilder<List<Caminhao>>(
            stream: controller.listarCaminhoes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Erro ao ler o Firebase: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final lista = snapshot.data!;
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.15,
                children: [
                  _card(lista, Caminhao.emUso, 'Em uso'),
                  _card(lista, Caminhao.disponivel, 'Disponíveis'),
                  _card(lista, Caminhao.quebrado, 'Quebrados'),
                  _card(lista, Caminhao.aEmplacar, 'A emplacar'),
                ],
              );
            },
          ),

          const SizedBox(height: 24),
          Botoes("Caminhões", Icons.local_shipping, onPressed: () {
            _novaTela(context, const FrotaPage());
          }),
          const SizedBox(height: 12),
          Botoes("Motoristas", Icons.badge, onPressed: () {
            _novaTela(context, const MotoristasPage());
          }),
        ],
      ),
    );
  }

  //Conta quantos caminhões estão com o status e monta o cartão
  Widget _card(List<Caminhao> lista, String status, String titulo) {
    final quantidade = lista.where((c) => c.status == status).length;
    return StatusCard(titulo, quantidade, corDoStatus(status), iconeDoStatus(status));
  }

  void _novaTela(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}
