import 'package:flutter/material.dart';
import 'package:gestao_frota/control/frota_controller.dart';
import 'package:gestao_frota/model/motorista.dart';
import 'package:gestao_frota/telas/form_motorista.dart';

//Lista de motoristas (RF02)
class MotoristasPage extends StatefulWidget {
  const MotoristasPage({super.key});

  @override
  State<MotoristasPage> createState() => _MotoristasPageState();
}

class _MotoristasPageState extends State<MotoristasPage> {
  final FrotaController controller = FrotaController();
  late final Stream<List<Motorista>> motoristas;

  @override
  void initState() {
    super.initState();
    motoristas = controller.listarMotoristas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Motoristas"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _novaTela(context, const FormMotorista());
        },
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text("Novo"),
      ),
      body: StreamBuilder<List<Motorista>>(
        stream: motoristas,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lista = snapshot.data!;
          if (lista.isEmpty) {
            return const Center(child: Text('Nenhum motorista cadastrado.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final m = lista[i];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey.shade100,
                    child: Text(
                      m.nome.isEmpty ? '?' : m.nome[0].toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(m.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'CNH: ${m.cnh}${m.telefone.isEmpty ? '' : '\nTelefone: ${m.telefone}'}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _novaTela(context, FormMotorista(motorista: m));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _novaTela(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}
