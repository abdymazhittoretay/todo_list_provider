import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_provider/services/auth.dart';

class FirestoreService {
  final CollectionReference _todos = FirebaseFirestore.instance.collection(
    "todos",
  );

  Future<void> addTodo(String todo) {
    return _todos.add({
      "user": Auth().currentUser!.email,
      "todo": [todo],
      "timestamp": Timestamp.now(),
    });
  }

  Future<void> updateTodo(String docID, String newTodo) {
    return _todos.doc(docID).update({
      "todo": newTodo,
      "timestamp": Timestamp.now(),
    });
  }

  Future<void> deleteTodo(String docID) {
    return _todos.doc(docID).delete();
  }
}
