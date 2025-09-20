import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_firebase_flutter/data/models/todos.dart';

class DatabaseService {
  static const String _todoReferenceName = "todos";

  late final _todoRef;

  DatabaseService() {
    _todoRef = FirebaseFirestore.instance
        .collection(_todoReferenceName)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Todos.fromJson(snapshot.data()!),
          toFirestore: (todo, options) => todo.toJson(),
        );
  }

  Stream<QuerySnapshot> getTodos() {
    return _todoRef.snapshots();
  }

  void addTodo(Todos todo) async {
    _todoRef.add(todo.toJson());
  }

  void updateTodo(String id, Todos updatedTodo) async {
    _todoRef.doc(id).update(updatedTodo.toJson());
  }
}
