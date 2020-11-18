import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String cidade;
  String pais;
  String cep;
  var temperatura;
  var tempoDescricao;
  var tempoAgora;
  var umidadeAr;
  var vento;

  var logradouro;
  var complemento;
  var bairro;
  var estado;
  var ddd;

  Future getWeather() async {
    http.Response response = await http.get(
      "http://api.openweathermap.org/data/2.5/weather?q=$cidade&Brasil&appid=44185947ca3544e1860c1fc810deb997",
    );
    var results = jsonDecode(response.body);

    setState(() {
      this.temperatura = results['main']['temp'];
      this.tempoDescricao = results['weather'][0]['description'];
      this.tempoAgora = results['weather'][0]['main'];
      this.umidadeAr = results['main']['humidity'];
      this.vento = results['wind']['speed'];
    });
  }

  Future getCep() async {
    http.Response response = await http.get(
      "https://viacep.com.br/ws/$cep/json/",
    );
    var results = jsonDecode(response.body);

    setState(() {
      this.logradouro = results['logradouro'];
      this.complemento = results['complemento'];
      this.bairro = results['bairro'];
      this.cidade = results['localidade'];
      cidade = this.cidade;
      this.estado = results['uf'];
      this.ddd = results['ddd'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = new Form(
      key: _key,
      autovalidate: _validate,
      child: _formUI(),
    );
    return MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('CEP & Clima'),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(15.0),
            child: form,
          ),
        ),
      ),
    );
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Digite o CEP'),
          maxLength: 40,
          validator: _validarCep,
          onSaved: (String val) {
            cep = val;
          },
        ),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Digite a Cidade'),
          maxLength: 40,
          validator: _validarCidade,
          onSaved: (String val) {
            cidade = val;
          },
        ),
        /*
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Pais'),
          maxLength: 40,
          validator: _validarCidade,
          onSaved: (String val) {
            cidade = val;
          },
        ),
        new RaisedButton(
          onPressed: _sendForm,
          child: new Text('Enviar'),
        ),
        */
        new RaisedButton(
          onPressed: _sendForm,
          child: new Text('Enviar'),
        ),
         Container(
           margin: const EdgeInsets.only(top: 15.0),
          child: Text('------ ENDEREÇO -------',
              style: TextStyle(
                fontSize: 30,
              )),
        ),
        Container(
          color: Colors.red[200],
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Logradouro: ' + logradouro.toString()
                  : "",
              style: TextStyle(
                fontSize: 27,
              )),
        ),
        Container(
          color: Colors.blue[200],
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Complemento: ' + complemento.toString()
                  : "",
              style: TextStyle(
                fontSize: 27,
              )),
        ),
        Container(
          color: Colors.deepOrange,
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Bairro: ' + bairro.toString()
                  : "",
              style: TextStyle(
                fontSize: 27,
              )),
        ),
        Container(
          color: Colors.deepPurple,
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Cidade: ' + cidade.toString()
                  : "",
              style: TextStyle(
                fontSize: 27,
              )),
        ),
        Container(
          color: Colors.lime,
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Estado: ' + estado.toString()
                  : "",
              style: TextStyle(
                fontSize: 27,
              )),
        ),
        Container(
          color: Colors.pink,
          child: Text(
              tempoDescricao.toString() != null ? 'DDD: ' + ddd.toString() : "",
              style: TextStyle(
                fontSize: 27,
              )),
        ),
          Image.network('https://respostas.sebrae.com.br/wp-content/uploads/2020/03/localiza%C3%A7%C3%A3o-da-sua-empresa-806x440.png'),
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          child: Text('------ CLIMA -------',
              style: TextStyle(
                fontSize: 30,
              )),
        ),
        Container(
          color: Colors.indigo[200],
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Descrição: ' + tempoDescricao.toString()
                  : "",
              style: TextStyle(
                fontSize: 27,
              )),
        ),
        Container(
          color: Colors.orange[300],
          child: Text(
              temperatura.toString().isNotEmpty != null
                  ? 'temperatura: ' + temperatura.toString()
                  : "",
              style: TextStyle(
                fontSize: 27,
              )),
        ),
        Container(
          color: Colors.redAccent,
          child: Text(
              umidadeAr.toString() != null
                  ? 'Umidade Ar: ' + umidadeAr.toString()
                  : "",
              style: TextStyle(
                fontSize: 27,
              )),
        ),
        Image.network('https://nordicapis.com/wp-content/uploads/5-Best-Free-and-Paid-Weather-APIs-2019-e1587582023501.png'),
      ],
    );
  }

  String _validarCidade(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe a cidade";
    } else if (!regExp.hasMatch(value)) {
      return "A cidade deve apenas caracteres de a-z ou A-Z";
    }
    return null;
  }

  String _validarCep(String value) {
    String patttern = r'(^[0-9 ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o cep";
    } else if (!regExp.hasMatch(value)) {
      return "o cep deve conter somente números";
    }
    return null;
  }

  _sendForm() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      this.getWeather();
      this.getCep();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
