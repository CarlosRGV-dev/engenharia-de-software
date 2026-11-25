//Representa um motorista da frota (coleção "motoristas" no Firebase)
class Motorista {
  String id;
  String nome;
  String cnh;
  String telefone;

  Motorista(this.id, this.nome, this.cnh, this.telefone);
  //construtor da classe

  //Converte o objeto em Map para salvar no Firebase
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cnh': cnh,
      'telefone': telefone,
    };
  }

  //Cria o objeto a partir do documento lido do Firebase
  factory Motorista.fromMap(String id, Map<String, dynamic> dados) {
    return Motorista(
      id,
      dados['nome'] ?? '',
      dados['cnh'] ?? '',
      dados['telefone'] ?? '',
    );
  }
}
