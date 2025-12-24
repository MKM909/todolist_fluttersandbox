import 'package:flutter/foundation.dart';
import '../models/tasks.dart';
import 'package:hive_flutter/hive_flutter.dart';

// All the [CRUD] operation methods for hive Db
class HiveDataStore{
  // Box name string
  static const boxName = 'taskBox';

  // our current box with all the saved data inside - Box<Task>
  final Box<Task> box = Hive.box<Task>(boxName);

  // Add new task to box
  Future<void> addTask ({required Task task}) async{
    await box.put(task.id, task);
  }

  // Show Task
  Future<Task?> getTask({required String id})async {
    return box.get(id);
  }

  // Update Task
  Future<void> updateTask({required Task task})async {
    await task.save();
  }

  // Delete Task
  Future<void> deleteTask({required Task task})async {
    await task.delete();
  }

  // Listen to Box Changes
  // With this method we will listen to box changes and update the ui accordingly
  ValueListenable<Box<Task>> listenToTask() => box.listenable();
}