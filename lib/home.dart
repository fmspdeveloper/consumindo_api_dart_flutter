import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class paginaInicio extends StatefulWidget {
  const paginaInicio({super.key});

  @override
  State<paginaInicio> createState() => _paginaInicioState();
}

class _paginaInicioState extends State<paginaInicio> {
  TextEditingController cepController = TextEditingController();
  String resultado = "";

  _recuperarCep() async {
    String cep = cepController.text;
    String url = "https://viacep.com.br/ws/${cep}/json/";
    Uri uri = Uri.parse(url);

    http.Response response;
    response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      String logradouro = data['logradouro'];
      String bairro = data['bairro'];
      String localidade = data['localidade'];
      String uf = data['uf'];

      setState(() {
        resultado = "CEP: $cep\n"
            "Logradouro: $logradouro\n"
            "Bairro: $bairro\n"
            "Localidade: $localidade\n"
            "UF: $uf";
      });
    } else {
      setState(() {
        resultado = "CEP Não encontrado";
      });
    }
  }

  void _limparCep() {
    setState(() {
      cepController.text = "";
      resultado = "";
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
              children: [
                TextField(
                  controller: cepController,
                  decoration: InputDecoration(labelText: "Digite seu CEP"),
                ),
                SizedBox(
                  height: 20,
                ),
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
