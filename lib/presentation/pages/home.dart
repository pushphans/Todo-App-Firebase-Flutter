import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_firebase_flutter/data/models/todos.dart';
import 'package:todo_app_firebase_flutter/data/services/database_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbService = DatabaseService();
  final titleController = TextEditingController();

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        title: Text("Add new Todo"),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "New Todo",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),

                SizedBox(width: 5),

                TextButton(
                  onPressed: () {
                    Todos todo = Todos(
                      title: titleController.text,
                      isDone: false,
                      createdOn: Timestamp.now(),
                    );

                    // print(todo.title);
                    // print(todo.isDone);
                    // print(todo.createdOn);

                    dbService.addTodo(todo);
                    Navigator.pop(context);
                    titleController.clear();
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Todos",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
      ),

      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,

        child: StreamBuilder(
          stream: dbService.getTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error Occurred ${snapshot.error}"));
            }

            if (snapshot.hasData) {
              List todos = snapshot.data?.docs ?? [];
              if (todos.isEmpty) {
                return const Center(child: Text("Add a Todo"));
              }

              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  Todos todo = todos[index].data();
                  String id = todos[index].id;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: ListTile(
                      onLongPress: () {
                        dbService.deleteTodo(id);
                      },
                      tileColor: Colors.deepPurple.shade200,
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,

                          decoration: todo.isDone == true
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat(
                          "dd-MM-yyyy  hh:mm a",
                        ).format(todo.createdOn.toDate()),
                      ),
                      trailing: Checkbox(
                        value: todo.isDone,
                        onChanged: (value) {
                          Todos updatedTodo = todo.copyWith(
                            isDone: !todo.isDone,
                          );

                          dbService.updateTodo(id, updatedTodo);
                        },
                      ),
                    ),
                  );
                },
              );
            }

            return Center(child: Text("Something went wrong"));
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade400,
        onPressed: openDialog,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
