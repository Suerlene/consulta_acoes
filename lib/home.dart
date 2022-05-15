import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

const request =
    "https://api.hgbrasil.com/finance/stock_price?key=410b24bd&symbol=";

Future<Map> getData(cod_acao) async {
  http.Response response = await http.get(Uri.parse(request + cod_acao));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Falha ao carregar dados...');
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override  
   State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double valor= 0.0;
  String acao = ""; 
  TextEditingController acao_entrada = TextEditingController();

void consultar() {
    print(request + acao_entrada.text);
    getData(acao_entrada.text);
     acao = acao_entrada.text;
    }

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consulta de valores de ações"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ), 
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Código da ação",
                    labelStyle: TextStyle(color: Colors.blueAccent)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 25.0),
                controller:  acao_entrada,
                validator: (String? value) {
                  if (value!.isEmpty) return "Insira o código da ação!";
                },
              ),
            
              Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Container(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                        consultar();
                        setState(() {});
                        },
                        child: Text(
                          "Consultar",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ))),
                      buildFutureBuilder(),
            ], //<widget>[]
          ),
        ),
      ),
    );
  }

buildFutureBuilder() {
    if (acao.isEmpty) {
      return Center(
          child: Text(
        "",
        style: TextStyle(color: Colors.amber, fontSize: 25.0),
        textAlign: TextAlign.center,
      ));
    } else {
      return FutureBuilder<Map>(
          future: getData(acao),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao carregar dados...",
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  valor =
                      snapshot.data?["results"][acao.toUpperCase()]["price"];
                    return Center(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          "$acao",
                          style: TextStyle(color: Colors.green, fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ),
                        Divider(color: Colors.transparent),
                        Text(
                          "R\$ $valor",
                          style: TextStyle(color: Colors.green, fontSize: 25.0),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ));
                }
            }
          });
  }
}
}