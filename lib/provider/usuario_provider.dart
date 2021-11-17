import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UsuarioProvider with ChangeNotifier, DiagnosticableTreeMixin  {

  String _usuarioNome = "(Não Logado)";

  String get usuarioNome => _usuarioNome;

  setUsarioNome(nome) {
    _usuarioNome = nome;
    notifyListeners();
  }

 /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('usuarioNome', usuarioNome));
  }  
}