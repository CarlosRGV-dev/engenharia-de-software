import 'package:gestao_frota/database/database_helper.dart';
import 'package:gestao_frota/model/caminhao.dart';
import 'package:gestao_frota/model/motorista.dart';

//Camada de controle: valida as Regras de Negócio (RN) antes de gravar no banco.
//Os métodos que gravam devolvem null quando deu certo,
//ou uma mensagem de erro para mostrar na tela.
class FrotaController {
  final DatabaseHelper db = DatabaseHelper();

  Stream<List<Caminhao>> listarCaminhoes() => db.listarCaminhoes();
  Stream<List<Motorista>> listarMotoristas() => db.listarMotoristas();
  Future<List<Motorista>> buscarMotoristas() => db.buscarMotoristas();

  // ---------------- MOTORISTAS ----------------

  //RF01 / RF02
  Future<String?> salvarMotorista(Motorista motorista) async {
    motorista.nome = motorista.nome.trim();
    motorista.cnh = motorista.cnh.trim();
    motorista.telefone = motorista.telefone.trim();

    if (motorista.nome.isEmpty || motorista.cnh.isEmpty) {
      return 'Preencha o nome e a CNH.';
    }
    //RN01: CNH única
    if (await db.cnhExiste(motorista.cnh, motorista.id)) {
      return 'Já existe um motorista com essa CNH.';
    }
    await db.salvarMotorista(motorista);
    if (motorista.id.isNotEmpty) {
      await db.atualizarNomeMotorista(motorista.id, motorista.nome);
    }
    return null;
  }

  Future<String?> excluirMotorista(Motorista motorista) async {
    //RN05: não exclui motorista que está em viagem
    final caminhoes = await db.caminhoesDoMotorista(motorista.id);
    if (caminhoes.isNotEmpty) {
      return 'Não é possível excluir: o motorista está em viagem '
          'com o caminhão ${caminhoes.first.placa}.';
    }
    await db.excluirMotorista(motorista.id);
    return null;
  }

  // ---------------- CAMINHÕES ----------------

  //RF03 / RF04 / RF05 / RF06
  Future<String?> salvarCaminhao(Caminhao caminhao) async {
    caminhao.placa = caminhao.placa.trim().toUpperCase();
    caminhao.modelo = caminhao.modelo.trim();
    caminhao.marca = caminhao.marca.trim();

    if (caminhao.placa.isEmpty || caminhao.modelo.isEmpty || caminhao.marca.isEmpty) {
      return 'Preencha a placa, o modelo e a marca.';
    }
    //RN06: só os 4 status padrão
    if (!Caminhao.listaStatus.contains(caminhao.status)) {
      return 'Status inválido.';
    }
    //RN01: placa única
    if (await db.placaExiste(caminhao.placa, caminhao.id)) {
      return 'Já existe um caminhão com essa placa.';
    }

    if (caminhao.status == Caminhao.emUso) {
      //RN02: caminhão em uso precisa de motorista
      if (caminhao.idMotorista.isEmpty) {
        return 'Escolha o motorista para colocar o caminhão em uso.';
      }
      //RN03: o motorista não pode estar em outro caminhão em uso
      final lista = await db.caminhoesDoMotorista(caminhao.idMotorista);
      final outros = lista.where((c) => c.id != caminhao.id).toList();
      if (outros.isNotEmpty) {
        return '${caminhao.nomeMotorista} já está com o caminhão ${outros.first.placa}.';
      }
    } else {
      //RN04 e RF07: fora de "Em uso" o caminhão fica sem motorista
      caminhao.idMotorista = '';
      caminhao.nomeMotorista = '';
    }

    await db.salvarCaminhao(caminhao);
    return null;
  }

  //RF07: encerra a viagem e libera o motorista
  Future<String?> encerrarViagem(Caminhao caminhao) async {
    caminhao.status = Caminhao.disponivel;
    return salvarCaminhao(caminhao);
  }

  Future<String?> excluirCaminhao(Caminhao caminhao) async {
    //RN05: não exclui caminhão em viagem
    if (caminhao.status == Caminhao.emUso) {
      return 'Não é possível excluir: encerre a viagem antes.';
    }
    await db.excluirCaminhao(caminhao.id);
    return null;
  }
}
