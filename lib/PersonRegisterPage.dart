import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

class PersonRegisterPage extends StatefulWidget {
  const PersonRegisterPage({Key? key}) : super(key: key);

  @override
  _PersonRegisterPageState createState() => _PersonRegisterPageState();
}

class _PersonRegisterPageState extends State<PersonRegisterPage> {
  var tfPersonName = TextEditingController();
  var tfTel = TextEditingController();

  Future<void> register(String person_name, String person_tel) async {

    var url = Uri.parse("http://kasimadalan.pe.hu/kisiler/insert_kisiler.php");
    var data = {"kisi_ad":person_name,"kisi_tel":person_tel};
    var response = await http.post(url,body: data);
    print("ekle ssonuç : ${response.body}");

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Person"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50.0,left: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                  controller: tfPersonName,
                  decoration: InputDecoration(hintText: "Name")),
              TextField(
                  controller: tfTel,
                  decoration: InputDecoration(hintText: "Phone")),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          register(tfPersonName.text, tfTel.text);
        },
        tooltip: 'RegisterPerson',
        icon: const Icon(Icons.save),
        label: Text("Register"),
      ),
    );
  }
}
