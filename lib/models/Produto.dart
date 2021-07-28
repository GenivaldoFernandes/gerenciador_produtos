class Produto {
  int id = 0;
  String imagem = "";
  String nome = "";
  double preco = 0;
  double precoPromocao = 0;
  double percentualDesconto = 0;
  int disponivelVenda = 0;

  Produto({
    required this.id,
    required this.imagem,
    required this.nome,
    required this.preco,
    required this.precoPromocao,
    required this.percentualDesconto,
    required this.disponivelVenda,
  });

  Map<String, dynamic> toMap() {
    return {
      'imagem': imagem,
      'nome': nome,
      'preco': preco,
      'preco_promocao': precoPromocao,
      'percentual_desconto': percentualDesconto,
      'disponivel_venda': disponivelVenda,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Produto{ id: $id, imagem: $imagem, nome: $nome, preco: $preco, preco_promocao: $precoPromocao, percentual_desconto: $percentualDesconto, disponivel_venda: $disponivelVenda}';
  }
}