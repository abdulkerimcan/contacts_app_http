import 'package:flutter/material.dart';
import 'Person.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PersonDetailPage extends StatefulWidget {
  Person person;


  PersonDetailPage(this.person);

  @override
  _PersonDetailPageState createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {

  var tfPersonName = TextEditingController();
  var tfTel = TextEditingController();


  Future<void> update(String person_id,String person_name, String person_tel) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/kisiler/update_kisiler.php");
    var data = {"kisi_id":person_id.toString(),"kisi_ad":person_name,"kisi_tel":person_tel};
    var response = await http.post(url,body: data);

    print("güncellme ssonuç : ${response.body}");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  void initState() {
    super.initState();

    var person = widget.person;

    tfPersonName.text = person.person_name;
    tfTel.text = person.person_tel;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.person.person_name}"),
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
          update(widget.person.person_id, tfPersonName.text, tfTel.text);
        },
        tooltip: 'Update',
        icon: const Icon(Icons.update),
        label: Text("Update"),
      ),
    );
  }
}
