import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
const request = "https://api.hgbrasil.com/finance";
void main() async{
  print(await getData());
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));


}



Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realControler = TextEditingController();
  final dolarControler = TextEditingController();
  final euroControler = TextEditingController();
  double dolar;
  double euro;
  double real;

  void _realChange(String text){
    double real = double.parse(text);
    dolarControler.text = (real/dolar).toStringAsFixed(2);
    euroControler.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChange(String text){

    double dolar= double.parse(text);
    realControler.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControler.text = (dolar * this.dolar/euro).toStringAsFixed(2);
  }

  void _euroChange(String text){
    double euro= double.parse(text);
    realControler.text = (euro * this.euro).toStringAsFixed(2);
    dolarControler.text = (euro * this.euro/dolar).toStringAsFixed(2);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados...",style: TextStyle(
                  color: Colors.amber,
                  fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao carregar dados :(",style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              }else{
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro  = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size:150,color:Colors.amber),
                    buildTextField("Reais", "R\$",realControler,_realChange),
                      Divider(),
                      buildTextField("Dolar", "US\$",dolarControler,_dolarChange),
                      Divider(),
                      buildTextField("Euro", "€",euroControler,_euroChange),

                    ],
                  ),
                );
              }
          }
        },
      ) ,
    );
  }
}

Widget buildTextField(String label, String pre,TextEditingController controler_moeda,Function f){
  return TextField(
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: pre
    ),
    style: TextStyle(
        color: Colors.amber,fontSize: 25
    ),
    controller: controler_moeda,
    onChanged: f,
    keyboardType: TextInputType.number,

  );
}