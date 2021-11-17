import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revenda/apis/api_login.dart';
import 'package:revenda/classes/cliente.dart';
import 'package:revenda/provider/usuario_provider.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({Key? key}) : super(key: key);

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final _edEmail = TextEditingController();
  final _edSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _quadroSuperior(context),
          _camposForm(context),
        ],
      ),
    );
  }

  _quadroSuperior(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final quadro = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Color.fromRGBO(73, 71, 205, 1.0),
          Color.fromRGBO(113, 13, 79, 1.0),
        ]),
      ),
    );

    final balao = Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.10),
      ),
    );

    return Stack(
      children: <Widget>[
        quadro,
        Positioned(child: balao, top: 120, left: 30),
        Positioned(child: balao, top: 50, left: 250),
        Positioned(child: balao, top: 150, right: -25),
        Positioned(child: balao, top: 200, left: 150),
        Positioned(child: balao, top: 10, left: 40),
        Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'images/fusca.png',
                fit: BoxFit.contain,
                height: 80,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Revenda Herbie',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _camposForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180,
            ),
          ),
          Container(
            width: size.width * 0.85,
            padding: const EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                const Text(
                  'Login do Cliente',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                _campoEmail(),
                _campoSenha(),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    _botaoAcesso(),
                    const SizedBox(
                      width: 8,
                    ),
                    _botaoVoltar(),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _campoEmail() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: TextField(
        controller: _edEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
            icon: Icon(
              Icons.alternate_email,
              color: Colors.blue,
            ),
            labelText: 'E-mail do Cliente:'),
      ),
    );
  }

  _campoSenha() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      child: TextField(
        controller: _edSenha,
        obscureText: true,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.lock_open,
            color: Colors.blue,
          ),
          labelText: 'Senha de Acesso:',
        ),
      ),
    );
  }

  ElevatedButton _botaoAcesso() {
    return ElevatedButton(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        child: const Text('Entrar'),
      ),
      onPressed: () async {
        await _verificaLogin();
      },
    );
  }

  ElevatedButton _botaoVoltar() {
    return ElevatedButton(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        child: const Text('Voltar'),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Future<void> _verificaLogin() async {
    if (_edEmail.text == '' || _edSenha.text == '') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Atenção:"),
          content:
              const Text("Preencha todos os campos ou clique no botão voltar"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
      return;
    }

    ApiLogin apiLogin = ApiLogin();
    final Cliente? cliente =
        await apiLogin.getLoginCliente(_edEmail.text, _edSenha.text);

    if (cliente == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Login Inválido"),
          content: const Text(
              "Informe novamente seus dados, ou clique no botão voltar"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } else {

      context.read<UsuarioProvider>().setUsarioNome(cliente.nome);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Login Efetuado com Sucesso!!"),
          content: const Text("Você pode agora avaliar os veículos"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }
}
