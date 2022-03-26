import 'package:contacts_app_http/Person.dart';

class PersonResponse {
  int success;
  List<Person> personList;

  PersonResponse(this.success, this.personList);

  factory PersonResponse.fromJson(Map<String,dynamic> json) {
    var jsonArray = json["kisiler"] as List;

    List<Person> personList = jsonArray.map((jsonObject) => Person.fromJson(jsonObject)).toList();

    return PersonResponse(json["success"] as int, personList);
  }
}