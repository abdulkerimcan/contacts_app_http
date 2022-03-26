class Person {
  String person_id;
  String person_name;
  String person_tel;

  Person(this.person_id, this.person_name, this.person_tel);

  factory Person.fromJson(Map<String,dynamic> json) {
    return Person(json["kisi_id"] as String, json["kisi_ad"] as String, json["kisi_tel"] as String);
  }
}