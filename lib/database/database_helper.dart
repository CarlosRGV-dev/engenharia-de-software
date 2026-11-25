import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_frota/model/caminhao.dart';
import 'package:gestao_frota/model/motorista.dart';

//Camada de banco: todas as leituras e gravações no Firebase Firestore
class DatabaseHelper {
  final FirebaseFirestore banco = FirebaseFirestore.instance;

  //Nomes das coleções no Firestore
  static const String colMotoristas = 'motoristas';
  static const String colCaminhoes = 'caminhoes';

  // ---------------- MOTORISTAS ----------------

  //Lista em tempo real, ordenada por nome
  Stream<List<Motorista>> listarMotoristas() {
    return banco.collection(colMotoristas).orderBy('nome').snapshots().map(
        (consulta) => consulta.docs
            .map((doc) => Motorista.fromMap(doc.id, doc.data()))
            .toList());
  }

  //Busca uma vez (usado no formulário do caminhão)
  Future<List<Motorista>> buscarMotoristas() async {
    final consulta = await banco.collection(colMotoristas).orderBy('nome').get();
    return consulta.docs.map((doc) => Motorista.fromMap(doc.id, doc.data())).toList();
  }

  Future<void> salvarMotorista(Motorista motorista) async {
    if (motorista.id.isEmpty) {
      await banco.collection(colMotoristas).add(motorista.toMap());
    } else {
      await banco.collection(colMotoristas).doc(motorista.id).set(motorista.toMap());
    }
  }

  Future<void> excluirMotorista(String id) async {
    await banco.collection(colMotoristas).doc(id).delete();
  }

  //true se outro motorista (id diferente) já usa essa CNH
  Future<bool> cnhExiste(String cnh, String idAtual) async {
    final consulta =
        await banco.collection(colMotoristas).where('cnh', isEqualTo: cnh).get();
    return consulta.docs.any((doc) => doc.id != idAtual);
  }

  // ---------------- CAMINHÕES ----------------

  //Lista em tempo real, ordenada por placa
  Stream<List<Caminhao>> listarCaminhoes() {
    return banco.collection(colCaminhoes).orderBy('placa').snapshots().map(
        (consulta) => consulta.docs
            .map((doc) => Caminhao.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> salvarCaminhao(Caminhao caminhao) async {
    if (caminhao.id.isEmpty) {
      await banco.collection(colCaminhoes).add(caminhao.toMap());
    } else {
      await banco.collection(colCaminhoes).doc(caminhao.id).set(caminhao.toMap());
    }
  }

  Future<void> excluirCaminhao(String id) async {
    await banco.collection(colCaminhoes).doc(id).delete();
  }

  //true se outro caminhão (id diferente) já usa essa placa
  Future<bool> placaExiste(String placa, String idAtual) async {
    final consulta =
        await banco.collection(colCaminhoes).where('placa', isEqualTo: placa).get();
    return consulta.docs.any((doc) => doc.id != idAtual);
  }

  //Caminhões que estão com esse motorista
  Future<List<Caminhao>> caminhoesDoMotorista(String idMotorista) async {
    final consulta = await banco
        .collection(colCaminhoes)
        .where('idMotorista', isEqualTo: idMotorista)
        .get();
    return consulta.docs.map((doc) => Caminhao.fromMap(doc.id, doc.data())).toList();
  }

  //Quando o motorista muda de nome, atualiza nos caminhões dele
  Future<void> atualizarNomeMotorista(String idMotorista, String nome) async {
    final lista = await caminhoesDoMotorista(idMotorista);
    for (final caminhao in lista) {
      await banco
          .collection(colCaminhoes)
          .doc(caminhao.id)
          .update({'nomeMotorista': nome});
    }
  }
}
