import 'package:flutter/material.dart';
import 'package:gestao_frota/control/frota_controller.dart';
import 'package:gestao_frota/model/motorista.dart';
import 'package:gestao_frota/widgets/botoes.dart';
import 'package:gestao_frota/widgets/input.dart';
import 'package:gestao_frota/widgets/mensagens.dart';
import 'package:gestao_frota/widgets/texto.dart';

//Cadastro e edição de motorista (RF01 / RF02)
class FormMotorista extends StatefulWidget {
  final Motorista? motorista; //null = novo motorista

  const FormMotorista({super.key, this.motorista});

  @override
  State<FormMotorista> createState() => _FormMotoristaState();
}

class _FormMotoristaState extends State<FormMotorista> {
  final FrotaController controller = FrotaController();
  final TextEditingController nome = TextEditingController();
  final TextEditingController cnh = TextEditingController();
  final TextEditingController telefone = TextEditingController();
  bool salvando = false;

  bool get editando => widget.motorista != null;

  @override
  void initState() {
    super.initState();
    final m = widget.motorista;
    if (m != null) {
      nome.text = m.nome;
      cnh.text = m.cnh;
      telefone.text = m.telefone;
    }
  }

  @override
  void dispose() {
    nome.dispose();
    cnh.dispose();
    telefone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? "Editar motorista" : "Novo motorista"),
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
          const Textos("Dados do motorista", Colors.blueGrey),
          const SizedBox(height: 16),
          Input("Nome completo", "Nome", controller: nome),
          Input("Número da CNH", "CNH",
              controller: cnh, teclado: TextInputType.number),
          Input("(15) 99999-9999", "Telefone",
              controller: telefone, teclado: TextInputType.phone),
          const SizedBox(height: 14),
          Botoes(salvando ? "Salvando..." : "Salvar", Icons.save, onPressed: () {
            if (!salvando) _salvar();
          }),
        ],
      ),
    );
  }

  Future<void> _salvar() async {
    setState(() {
      salvando = true;
    });
    final motorista = Motorista(
      widget.motorista?.id ?? '',
      nome.text,
      cnh.text,
      telefone.text,
    );
    final erro = await controller.salvarMotorista(motorista);
    if (!mounted) return;
    setState(() {
      salvando = false;
    });
    if (erro != null) {
      mostrarAviso(context, erro);
    } else {
      mostrarAviso(context, 'Motorista salvo!');
      Navigator.pop(context);
    }
  }

  Future<void> _excluir() async {
    final ok = await confirmar(context, 'Excluir o motorista ${widget.motorista!.nome}?');
    if (!ok) return;
    final erro = await controller.excluirMotorista(widget.motorista!);
    if (!mounted) return;
    if (erro != null) {
      mostrarAviso(context, erro);
    } else {
      mostrarAviso(context, 'Motorista excluído.');
      Navigator.pop(context);
    }
  }
}
