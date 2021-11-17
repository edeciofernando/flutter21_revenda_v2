class Cliente {
  final int id;
  final String nome;
  final String token;

  Cliente({
    required this.id,
    required this.nome,
    required this.token,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
        id: json['id'],
        nome: json['nome'],
        token: json['token']);
  }
}
