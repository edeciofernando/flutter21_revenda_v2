import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:revenda/classes/carro.dart';

class ApiCarros {
  final String url = 'http://localhost:3001/carros';

// A function that converts a response body into a List<Carro>.
  List<Carro> parseCarros(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Carro>((json) => Carro.fromJson(json)).toList();
  }

  Future<List<Carro>> obterCarros(http.Client client) async {
    final response = await client.get(Uri.parse(url));

    // Use the compute function to run parseCarros in a separate isolate.
    return compute(parseCarros, response.body);
  }

  Future<http.Response> deleteCarro(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('$url/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to delete album.');
    }
  }

  Future<String> createCarro(
      String modelo, int marcaId, String foto, int ano, double preco) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'modelo': modelo,
        'marca_id': marcaId,
        'foto': foto,
        'ano': ano,
        'preco': preco,
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      // return Carro.fromJson(jsonDecode(response.body));
      return "Ok! Veículo Inserido com Sucesso";
    } else {
      throw Exception('Failed to create album.');
    }
  }
}
