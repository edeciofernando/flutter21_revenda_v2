import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:revenda/classes/cliente.dart';

class ApiLogin {
  final String url = 'http://localhost:3001/login';

  getLoginCliente(String email, String senha) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      var lista = json.decode(response.body);

   //   print(lista);
   //   print(lista["userId"]);
   //   print(lista["user"]);

      if (lista["userId"] == null) {
        return null;
      } else {
        return Cliente(id: lista["userId"], nome: lista["user"], token: lista["token"]);
      }
    } else {
      throw Exception('Erro ao conectar com WebService');
    }
  }
}
