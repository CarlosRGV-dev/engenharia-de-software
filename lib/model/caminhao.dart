//Representa um caminhão da frota (coleção "caminhoes" no Firebase)
class Caminhao {
  //RN06: os únicos status permitidos no sistema
  static const String aEmplacar = 'A emplacar';
  static const String disponivel = 'Disponível';
  static const String emUso = 'Em uso';
  static const String quebrado = 'Quebrado';
  static const List<String> listaStatus = [aEmplacar, disponivel, emUso, quebrado];

  String id;
  String placa;
  String modelo;
  String marca;
  int ano;
  String status;
  String idMotorista; //vazio quando não tem motorista
  String nomeMotorista; //guardado junto para mostrar na lista

  Caminhao(this.id, this.placa, this.modelo, this.marca, this.ano, this.status,
      this.idMotorista, this.nomeMotorista);
  //construtor da classe

  //Converte o objeto em Map para salvar no Firebase
  Map<String, dynamic> toMap() {
    return {
      'placa': placa,
      'modelo': modelo,
      'marca': marca,
      'ano': ano,
      'status': status,
      'idMotorista': idMotorista,
      'nomeMotorista': nomeMotorista,
    };
  }

  //Cria o objeto a partir do documento lido do Firebase
  factory Caminhao.fromMap(String id, Map<String, dynamic> dados) {
    //RN06: se vier um status diferente dos 4 padrão, considera "Disponível"
    String status = dados['status'] ?? disponivel;
    if (!listaStatus.contains(status)) status = disponivel;

    return Caminhao(
      id,
      dados['placa'] ?? '',
      dados['modelo'] ?? '',
      dados['marca'] ?? '',
      int.tryParse('${dados['ano']}') ?? 0,
      status,
      dados['idMotorista'] ?? '',
      dados['nomeMotorista'] ?? '',
    );
  }
}
