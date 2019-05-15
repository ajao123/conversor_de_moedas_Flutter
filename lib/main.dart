import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=1b40383c';

void main() async{

  print(await getData());

  runApp(MaterialApp(
    home: HOME(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    ),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return (json.decode(response.body));
}

class HOME extends StatefulWidget {
  @override
  _HOMEState createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {

  double dolar, euro;
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar*this.dolar)/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro*this.euro).toStringAsFixed(2);
    dolarController.text = ((euro*this.euro)/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar:AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados ...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                textAlign: TextAlign.center)
              );

            default:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao Carregar Dados !!!",
                    style: TextStyle(color:Colors.amber, fontSize: 25.0),
                  textAlign:TextAlign.center)
                );
              }else{
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch
                    ,children: <Widget>[
                      Icon(Icons.monetization_on, color: Colors.amber, size: 150.0, ),
                      Divider(),
                    buildTextField("Real", "R\$ ", realController, _realChanged),
                      Divider(),
                    buildTextField("Dolar", "US\$ ", dolarController, _dolarChanged),
                      Divider(),
                    buildTextField("Euro", "€ ", euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function function){
  return TextField(
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color:Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix
      ),
      style:TextStyle(color:Colors.amber , fontSize: 25.0),
      onChanged: function,
  );
}