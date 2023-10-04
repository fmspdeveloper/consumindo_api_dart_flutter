import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Endereco {
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  Endereco({
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });
}

class paginaInicio extends StatefulWidget {
  const paginaInicio({super.key});

  @override
  State<paginaInicio> createState() => _paginaInicioState();
}

class _paginaInicioState extends State<paginaInicio> {
  TextEditingController cepController = TextEditingController();
  String resultado = "";
  Endereco endereco =
      Endereco(logradouro: "", bairro: "", localidade: "", uf: "");

  _recuperarCep() async {
    String cep = cepController.text;
    String url = "https://viacep.com.br/ws/${cep}/json/";
    Uri uri = Uri.parse(url);

    http.Response response;
    response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        endereco = Endereco(
          logradouro: data['logradouro'] ?? "",
          bairro: data['bairro'] ?? "",
          localidade: data['localidade'] ?? "",
          uf: data['uf'] ?? "",
        );
      });
    } else {
      setState(() {
        endereco = Endereco(logradouro: "", bairro: "", localidade: "", uf: "");
        resultado = "CEP Não encontrado";
      });
    }
  }

  void _limparCep() {
    setState(() {
      cepController.text = "";
      resultado = "";
      endereco = Endereco(logradouro: "", bairro: "", localidade: "", uf: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar Cep"),
        actions: [
          IconButton(
            onPressed: _limparCep,
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Container(
        child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: cepController,
                  decoration: InputDecoration(labelText: "Digite seu CEP"),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Logradouro: ${endereco.logradouro}"),
                Text("Bairro: ${endereco.bairro}"),
                Text("Localidade: ${endereco.localidade}"),
                Text("uf: ${endereco.uf}"),
                ElevatedButton(
                  onPressed: _recuperarCep,
                  child: Text("Buscar CEP"),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  resultado,
                  style: TextStyle(fontSize: 20),
                )
              ],
            )),
      ),
    );
  }
}
