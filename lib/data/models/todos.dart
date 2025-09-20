import 'package:cloud_firestore/cloud_firestore.dart';

class Todos {
  final String title;
  final bool isDone;
  final Timestamp createdOn;

  Todos({required this.title, required this.isDone, required this.createdOn});

  Todos copyWith({String? title, bool? isDone, Timestamp? createdOn}) {
    return Todos(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  factory Todos.fromJson(Map<String, dynamic> map) {
    return Todos(
      title: map['title'] as String,
      isDone: map['isDone'] as bool,
      createdOn: map['createdOn'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'isDone': isDone, 'createdOn': createdOn};
  }
}
