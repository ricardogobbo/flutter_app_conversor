import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double USD = 0;
  double EUR = 0;

  var reaisController = TextEditingController();
  var dolarController = TextEditingController();
  var eurosController = TextEditingController();

  @override
  initState() {
    super.initState();
    getQuotes();
    return;
  }

  getQuotes() {
    var url = 'https://api.hgbrasil.com/finance?key=dea4c574';
    var response = http.get(url).then((value) {
      var jsonResponse = convert.jsonDecode(value.body);

      setState(() {
        USD = jsonResponse['results']['currencies']['USD']['buy'];
        EUR = jsonResponse['results']['currencies']['EUR']['buy'];
      });
    });
  }

  _changeField(int field) {
    switch (field) {
      case 1:
        double value = double.tryParse(reaisController.text);
        dolarController.text = (value / USD).toStringAsFixed(2);
        eurosController.text = (value / EUR).toStringAsFixed(2);
        break;
      case 2:
        double value = double.tryParse(dolarController.text);
        reaisController.text = (value * USD).toStringAsFixed(2);
        eurosController.text = (value * USD / EUR).toStringAsFixed(2);
        break;
      case 3:
        double value = double.tryParse(eurosController.text);
        reaisController.text = (value * EUR).toStringAsFixed(2);
        dolarController.text = (value * EUR / USD).toStringAsFixed(2);
        break;
    }
  }

  _refresh() {
    reaisController.text = "";
    dolarController.text = "";
    eurosController.text = "";
    debugPrint("refreshed");
    getQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        hintColor: Colors.blue,
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(
            "Conversor de Moedas",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _refresh();
              },
              icon: Icon(Icons.refresh),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'images/conversion.png',
                height: 150,
              ),
              Divider(),
              buildTextField(
                  reaisController, "Reais", Icon(Icons.monetization_on), 1),
              Divider(),
              buildTextField(
                  dolarController, "Dólar", Icon(Icons.attach_money), 2),
              Divider(),
              buildTextField(
                  eurosController, "Euro", Icon(Icons.euro_symbol), 3)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      Icon suffix, int conversionType) {
    return TextField(
        controller: controller,
        onChanged: (str) {
          _changeField(conversionType);
        },
        style: TextStyle(fontSize: 25, color: Colors.blue),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.blue, fontSize: 25),
          suffixIcon: suffix,
        ),
        keyboardType: TextInputType.number);
  }
}
