import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tasks_app/app/data/models/task.dart';
import 'package:tasks_app/app/data/services/storage/repository.dart';

class HomeController extends GetxController {
  final TaskRepository taskRepository;

  HomeController({required this.taskRepository});

  final tasks = <Task>[].obs;
  final formKey = GlobalKey<FormState>();
  final editCtrl = TextEditingController();
  final deleting = false.obs;
  final chipIndex = 0.obs;
  final task = Rx<Task?>(null);

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    editCtrl.dispose();
    super.onClose();
  }

  void changeChipIndex(int index) {
    chipIndex.value = index;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? select) {
    task.value = select;
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  updateTask(
    Task task,
    String title,
  ) {
    var todos = task.todos ?? [];
    if (containsTodo(todos, title)) {
      // todos already exist.
      return false;
    }
    // create new todo
    var todo = {'title': title, 'done': false};
    // add to todos list
    todos.add(todo);
    // update todos list in task object
    var newTask = task.copyWith(todos: todos);
    // find task position
    int oldIndex = tasks.indexOf(task);
    // update it
    tasks[oldIndex] = newTask;
    tasks.refresh();

    return true; // add success!
  }

  bool containsTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }
}
