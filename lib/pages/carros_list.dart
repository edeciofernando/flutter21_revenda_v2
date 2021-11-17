import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revenda/classes/carro.dart';
import 'package:revenda/apis/api_carros.dart';

class CarrosList extends StatefulWidget {
  //const CarrosList3({Key? key, required this.carros}) : super(key: key);
  CarrosList({Key? key, required this.carros}) : super(key: key);

//  final List<Carro> carros;
  List<Carro> carros;

  @override
  State<CarrosList> createState() => _CarrosListState();
}

class _CarrosListState extends State<CarrosList> {
  ApiCarros apiCarros = ApiCarros();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.carros.length,
      itemBuilder: (BuildContext context, int index) {
        Carro carro = widget.carros[index];
        return appBodyImage(context, carro.id, carro.foto, carro.modelo,
            carro.marca, carro.ano, carro.preco);
      },
    );
  }

  ListTile appBodyImage(BuildContext context, int id, String foto,
      String modelo, String marca, int ano, double preco) {
    return (ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          foto,
        ),
      ),
      title: Text(marca + " " + modelo),
      subtitle: Text("Ano: " +
          ano.toString() +
          "\n" +
          NumberFormat.simpleCurrency(locale: "pt_BR").format(preco)),
      isThreeLine: true,
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Exclusão'),
              content: Text('Confirma a exclusão do veículo $modelo?'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // exclui o registro a partir de uma chamada ao Web Services
                    apiCarros.deleteCarro(id.toString());
                    // atualiza o estado, do array de carros, para refletir na listagem
                    setState(() {
                      widget.carros = widget.carros
                          .where((carro) => carro.id != id)
                          .toList();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Sim'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Não'),
                ),
              ],
            );
          },
        );
      },
    ));
  }
}
