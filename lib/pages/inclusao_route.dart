import 'dart:async';
//import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revenda/apis/api_carros.dart';
import 'package:revenda/apis/api_marcas.dart';
import 'package:revenda/classes/marca.dart';

class InclusaoRoute extends StatefulWidget {
  const InclusaoRoute({Key? key}) : super(key: key);

  @override
  _InclusaoRouteState createState() => _InclusaoRouteState();
}

class _InclusaoRouteState extends State<InclusaoRoute> {
  final _edModelo = TextEditingController();
  final _edPreco = TextEditingController();
  final _edAno = TextEditingController();
  final _edFoto = TextEditingController();
  int _marcaId = 1;

  ApiMarcas apiMarcas = ApiMarcas();
  ApiCarros apiCarros = ApiCarros();

  late List<Marca> marcas;

  FutureOr carregaMarcas() async {
    marcas = await apiMarcas.obterMarcas(http.Client());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    carregaMarcas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inclusão de Veículos'),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Voltar',
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Container _body() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _edModelo,
            keyboardType: TextInputType.name,
            style: const TextStyle(
              fontSize: 20,
            ),
            decoration: const InputDecoration(
              labelText: "Modelo",
            ),
          ),
          Row(
            children: [
              DropdownButton(
                value: _marcaId,
                items: marcas.map((marca) {
                  return DropdownMenuItem(
                    child: Text(marca.nome),
                    value: marca.id,
                  );
                }).toList(),
                onChanged: (int? value) {
                  setState(() {
                    _marcaId = value!;
                  });
                },
                hint: const Text("Selecione a Marca"),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: _edAno,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Ano",
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _edPreco,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 20,
            ),
            decoration: const InputDecoration(
              labelText: "Preço R\$",
            ),
          ),
          TextFormField(
            controller: _edFoto,
            keyboardType: TextInputType.url,
            style: const TextStyle(
              fontSize: 20,
            ),
            decoration: const InputDecoration(
              labelText: "URL da Foto",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: _gravaDados,
              child: const Text("Incluir",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _gravaDados() async {
    if (_edModelo.text == "" ||
        _edPreco.text == "" ||
        _edAno.text == "" ||
        _edFoto.text == "") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Atenção'),
              content: const Text('Por favor, preencha todos os campos'),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok')),
              ],
            );
          });
      return;
    }

    String novo = await apiCarros.createCarro(
      _edModelo.text,
      _marcaId,
      _edFoto.text,
      int.parse(_edAno.text),
      double.parse(_edPreco.text),
    );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cadastrado Concluído!'),
            content: Text(novo),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok')),
            ],
          );
        });

    _edModelo.text = "";
    _marcaId = 1;
    _edPreco.text = "";
    _edAno.text = "";
    _edFoto.text = "";
  }
}
