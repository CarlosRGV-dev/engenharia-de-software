import 'package:flutter/material.dart';
import 'package:gestao_frota/control/frota_controller.dart';
import 'package:gestao_frota/model/caminhao.dart';
import 'package:gestao_frota/telas/form_caminhao.dart';
import 'package:gestao_frota/widgets/mensagens.dart';
import 'package:gestao_frota/widgets/status_card.dart';

//Lista de caminhões com busca por placa e filtro por status (RF04 / RF08)
class FrotaPage extends StatefulWidget {
  const FrotaPage({super.key});

  @override
  State<FrotaPage> createState() => _FrotaPageState();
}

class _FrotaPageState extends State<FrotaPage> {
  final FrotaController controller = FrotaController();
  late final Stream<List<Caminhao>> caminhoes;
  String busca = '';
  String filtro = 'Todos';

  @override
  void initState() {
    super.initState();
    caminhoes = controller.listarCaminhoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Caminhões"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _novaTela(context, const FormCaminhao());
        },
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Novo"),
      ),
      body: Column(
        children: [
          //Busca por placa
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar pela placa',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (texto) {
                setState(() {
                  busca = texto.trim().toUpperCase();
                });
              },
            ),
          ),

          //Filtro por status
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Todos', ...Caminhao.listaStatus].map((status) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: filtro == status,
                    onSelected: (_) {
                      setState(() {
                        filtro = status;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          //Lista
          Expanded(
            child: StreamBuilder<List<Caminhao>>(
              stream: caminhoes,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final lista = snapshot.data!.where((c) {
                  final passaBusca = c.placa.contains(busca);
                  final passaFiltro = filtro == 'Todos' || c.status == filtro;
                  return passaBusca && passaFiltro;
                }).toList();

                if (lista.isEmpty) {
                  return const Center(child: Text('Nenhum caminhão encontrado.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                  itemCount: lista.length,
                  itemBuilder: (context, i) => _cardCaminhao(lista[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardCaminhao(Caminhao caminhao) {
    final cor = corDoStatus(caminhao.status);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: cor.shade100,
          child: Icon(iconeDoStatus(caminhao.status), color: cor.shade700),
        ),
        title: Text(caminhao.placa,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${caminhao.modelo} • ${caminhao.marca} • ${caminhao.ano}'),
            if (caminhao.nomeMotorista.isNotEmpty)
              Text('Motorista: ${caminhao.nomeMotorista}'),
            const SizedBox(height: 6),
            EtiquetaStatus(caminhao.status),
          ],
        ),
        //Caminhão em uso mostra o botão de encerrar a viagem (RF07)
        trailing: caminhao.status == Caminhao.emUso
            ? IconButton(
                tooltip: 'Encerrar viagem',
                icon: const Icon(Icons.flag, color: Colors.blue),
                onPressed: () => _encerrarViagem(caminhao),
              )
            : const Icon(Icons.chevron_right),
        onTap: () {
          _novaTela(context, FormCaminhao(caminhao: caminhao));
        },
      ),
    );
  }

  Future<void> _encerrarViagem(Caminhao caminhao) async {
    final ok = await confirmar(context, 'Encerrar a viagem do ${caminhao.placa}?');
    if (!ok) return;
    final erro = await controller.encerrarViagem(caminhao);
    if (!mounted) return;
    mostrarAviso(context, erro ?? 'Viagem encerrada. Caminhão disponível.');
  }

  void _novaTela(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}
