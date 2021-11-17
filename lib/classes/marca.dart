class Marca {
  final int id;
  final String nome;

  Marca({
    required this.id,
    required this.nome,
  });

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
        id: json['id'],
        nome: json['nome']);
  }
}
