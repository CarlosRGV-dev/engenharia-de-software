import 'package:flutter/material.dart';
import 'package:gestao_frota/control/frota_controller.dart';
import 'package:gestao_frota/model/caminhao.dart';
import 'package:gestao_frota/model/motorista.dart';
import 'package:gestao_frota/widgets/botoes.dart';
import 'package:gestao_frota/widgets/input.dart';
import 'package:gestao_frota/widgets/mensagens.dart';
import 'package:gestao_frota/widgets/texto.dart';

//Cadastro e edição de caminhão (RF03 / RF05 / RF06)
class FormCaminhao extends StatefulWidget {
  final Caminhao? caminhao; //null = novo caminhão

  const FormCaminhao({super.key, this.caminhao});

  @override
  State<FormCaminhao> createState() => _FormCaminhaoState();
}

class _FormCaminhaoState extends State<FormCaminhao> {
  final FrotaController controller = FrotaController();
  final TextEditingController placa = TextEditingController();
  final TextEditingController modelo = TextEditingController();
  final TextEditingController marca = TextEditingController();
  final TextEditingController ano = TextEditingController();

  String status = Caminhao.disponivel;
  String idMotorista = '';
  List<Motorista> motoristas = [];
  bool carregando = true;
  bool salvando = false;

  bool get editando => widget.caminhao != null;

  @override
  void initState() {
    super.initState();
    final c = widget.caminhao;
    if (c != null) {
      placa.text = c.placa;
      modelo.text = c.modelo;
      marca.text = c.marca;
      ano.text = c.ano == 0 ? '' : '${c.ano}';
      status = c.status;
      idMotorista = c.idMotorista;
    }
    _carregarMotoristas();
  }

  Future<void> _carregarMotoristas() async {
    final lista = await controller.buscarMotoristas();
    if (!mounted) return;
    setState(() {
      motoristas = lista;
      carregando = false;
    });
  }

  @override
  void dispose() {
    placa.dispose();
    modelo.dispose();
    marca.dispose();
    ano.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? "Editar caminhão" : "Novo caminhão"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          if (editando)
            IconButton(
              onPressed: _excluir,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Textos("Dados do veículo", Colors.blueGrey),
          const SizedBox(height: 16),
          Input("Ex.: ABC1D23", "Placa", controller: placa),
          Input("Ex.: FH 540", "Modelo", controller: modelo),
          Input("Ex.: Volvo", "Marca", controller: marca),
          Input("Ex.: 2020", "Ano de fabricação",
              controller: ano, teclado: TextInputType.number),

          const Textos("Situação", Colors.blueGrey, tamanho: 18),
          const SizedBox(height: 8),

          //Status do caminhão (RF05 / RN06)
          DropdownButton<String>(
            value: status,
            isExpanded: true,
            items: Caminhao.listaStatus.map((s) {
              return DropdownMenuItem(value: s, child: Text(s));
            }).toList(),
            onChanged: (valor) {
              setState(() {
                status = valor!;
              });
            },
          ),

          //Motorista só aparece quando o caminhão está "Em uso" (RF06 / RN04)
          if (status == Caminhao.emUso) ...[
            const SizedBox(height: 12),
            const Text("Motorista"),
            DropdownButton<String>(
              value: _motoristaExiste() ? idMotorista : null,
              hint: Text(carregando
                  ? 'Carregando...'
                  : motoristas.isEmpty
                      ? 'Cadastre um motorista primeiro'
                      : 'Escolha o motorista'),
              isExpanded: true,
              items: motoristas.map((m) {
                return DropdownMenuItem(value: m.id, child: Text(m.nome));
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  idMotorista = valor ?? '';
                });
              },
            ),
          ],

          const SizedBox(height: 28),
          Botoes(salvando ? "Salvando..." : "Salvar", Icons.save, onPressed: () {
            if (!salvando) _salvar();
          }),
        ],
      ),
    );
  }

  bool _motoristaExiste() {
    return motoristas.any((m) => m.id == idMotorista);
  }

  String _nomeMotorista() {
    for (final m in motoristas) {
      if (m.id == idMotorista) return m.nome;
    }
    return '';
  }

  Future<void> _salvar() async {
    setState(() {
      salvando = true;
    });
    final caminhao = Caminhao(
      widget.caminhao?.id ?? '',
      placa.text,
      modelo.text,
      marca.text,
      int.tryParse(ano.text.trim()) ?? 0,
      status,
      _motoristaExiste() ? idMotorista : '',
      _nomeMotorista(),
    );
    final erro = await controller.salvarCaminhao(caminhao);
    if (!mounted) return;
    setState(() {
      salvando = false;
    });
    if (erro != null) {
      mostrarAviso(context, erro);
    } else {
      mostrarAviso(context, 'Caminhão salvo!');
      Navigator.pop(context);
    }
  }

  Future<void> _excluir() async {
    final ok = await confirmar(context, 'Excluir o caminhão ${widget.caminhao!.placa}?');
    if (!ok) return;
    final erro = await controller.excluirCaminhao(widget.caminhao!);
    if (!mounted) return;
    if (erro != null) {
      mostrarAviso(context, erro);
    } else {
      mostrarAviso(context, 'Caminhão excluído.');
      Navigator.pop(context);
    }
  }
}
