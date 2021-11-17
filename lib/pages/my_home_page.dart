import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revenda/classes/carro.dart';
import 'package:revenda/pages/carros_list.dart';
import 'package:revenda/pages/inclusao_route.dart';
import 'package:revenda/pages/login_route.dart';
import 'package:revenda/provider/usuario_provider.dart';
import 'package:http/http.dart' as http;
import 'package:revenda/apis/api_carros.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FutureOr atualizaState(dynamic value) {
    // atualiza (faz um refresh) na activity
    setState(() {});
  }

  ApiCarros apiCarros = ApiCarros();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(widget.title),
            Text(
              "Usuário: " + context.watch<UsuarioProvider>().usuarioNome,
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginRoute()),
              );
            },
            icon: const Icon(Icons.login_sharp),
          ),
        ],
      ),
      body: FutureBuilder<List<Carro>>(
        future: apiCarros.obterCarros(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return CarrosList(carros: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (context.read<UsuarioProvider>().usuarioNome != "(Não Logado)") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InclusaoRoute()),
            ).then(atualizaState);
          } else {
            print("Erro");
          }
        },
        tooltip: 'Adicionar Carro',
        child: const Icon(Icons.add),
      ),
    );
  }
}
