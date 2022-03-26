import 'dart:io';
import 'dart:convert';
import 'package:contacts_app_http/PersonResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'Person.dart';
import 'PersonDetailPage.dart';
import 'PersonRegisterPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSearching = false;
  String searching_word = "";

  List<Person> personResponseParse(String response) {
    return PersonResponse.fromJson(json.decode(response)).personList;
  }

  Future<List<Person>> getAllPerson() async {
    var url = Uri.parse("http://kasimadalan.pe.hu/kisiler/tum_kisiler.php");
    var response = await http.get(url);

    return personResponseParse(response.body);
  }

  Future<List<Person>> searchPerson(String searchWord) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/kisiler/tum_kisiler_arama.php");
    var data = {"kisi_ad":searchWord};

    var response = await http.post(url,body: data);

    return personResponseParse(response.body);
  }

  Future<void> deletePerson(String person_id) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/kisiler/delete_kisiler.php");
    var data = {"kisi_id":person_id.toString()};
    var cevap = await http.post(url,body: data);

    setState(() {});

  }

  Future<bool> shutTheApp() async {
    await exit(0);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              shutTheApp();
            },
            icon: Icon(Icons.arrow_back)),
        title: isSearching
            ? TextField(
                decoration: InputDecoration(hintText: "Search"),
                onChanged: (result) {
                  setState(() {
                    searching_word = result;
                  });
                })
            : Text("Contacts App"),
        actions: [
          isSearching
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searching_word = "";
                    });
                  },
                  icon: Icon(Icons.cancel))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                  icon: Icon(Icons.search)),
        ],
      ),
      body: WillPopScope(
        onWillPop: shutTheApp,
        child: FutureBuilder<List<Person>>(
          future: isSearching ? searchPerson(searching_word) : getAllPerson(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var personList = snapshot.data;
              return ListView.builder(
                itemCount: personList!.length,
                itemBuilder: (context, index) {
                  var person = personList[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PersonDetailPage(person)));
                    },
                    child: Card(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("${person.person_name}"),
                            Text("${person.person_tel}"),
                            IconButton(
                                onPressed: () {
                                  deletePerson(person.person_id);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PersonRegisterPage()));
        },
        tooltip: 'Add Person',
        child: const Icon(Icons.add),
      ),
    );
  }
}
