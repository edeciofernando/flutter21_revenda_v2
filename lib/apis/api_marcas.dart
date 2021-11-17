import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:revenda/classes/marca.dart';
import 'package:http/http.dart' as http;

class ApiMarcas {
  final String url = 'http://localhost:3001/marcas';

  // A function that converts a response body into a List<Carro>.
  List<Marca> parseMarcas(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Marca>((json) => Marca.fromJson(json)).toList();
  }

  Future<List<Marca>> obterMarcas(http.Client client) async {
    final response = await client.get(Uri.parse(url));

    // Use the compute function to run parseCarros in a separate isolate.
    return compute(parseMarcas, response.body);
  }
}
