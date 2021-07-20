import 'package:flutter/foundation.dart';

class Band {
  String id, name;
  int votes;

  Band({
    this.id,
    this.name,
    this.votes,
  });

  Band.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        votes = map['votes'];

/* Factory como alternativa al contructor por lista de parametros
  Ambos hacen lo mismo, constuir el objeto en base a un mapa
  */
  factory Band.fromMapa(Map<String, dynamic> map) =>
      Band(id: map['id'], name: map['name'], votes: map['votes']);
}
