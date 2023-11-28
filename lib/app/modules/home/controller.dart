import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;
  final tabIndex = 0.obs;

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

  void changeTodos(List<dynamic> select) {
    // reset todos list
    doingTodos.clear();
    doneTodos.clear();

    // for all todos
    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        // check todo completed or doing
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  bool addTodo(String title) {
    // check new todo already exist in doingTodos or not
    var todo = {'title': title, 'done': false};
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }

    // check new todo already exist in doneTodos or not
    var doneTodo = {'title': title, 'done': true};
    if (doneTodos
        .any((element) => mapEquals<String, dynamic>(doneTodo, element))) {
      return false;
    }

    // can be added
    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    // create all todos list(doing & completed)
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);

    // update todos list in task
    var newTask = task.value!.copyWith(
      todos: newTodos,
    );

    int oldIndex = tasks.indexOf(task.value);
    tasks[oldIndex] = newTask;

    tasks.refresh();
  }

  void doneTodo(String title) {
    // remove todo from doing list (todo is completed)
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);

    // after delete, added todo to done list
    var doneTodo = {'title': title, 'done': true};
    doneTodos.add(doneTodo);

    // refresh lists
    doingTodos.refresh();
    doneTodos.refresh();
  }

  deleteDoneTodo(dynamic doneTodo) {
    // find todo in list
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    // remove it
    doneTodos.removeAt(index);
    // refresh list
    doneTodos.refresh();
  }

  bool isTodosEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  // all [completed] todos in special task
  int getDoneTodosNumber(Task task) {
    var count = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) count += 1;
    }
    return count;
  }

  // all todos [doing and completed] in all tasks
  int getTotalTodosNumber() {
    var count = 0;
    for (int i = 0; i < tasks.length; i++) {
      // for all tasks
      if (tasks[i].todos != null) {
        // task have todo
        count = tasks[i].todos!.length; // all todos item exist in task
      }
    }
    return count;
  }

  // all todos [completed] in all tasks
  int getTotalDoneTaskNumber() {
    var count = 0;
    for (int i = 0; i < tasks.length; i++) {
      // for all tasks
      if (tasks[i].todos != null) {
        // task have todo
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          // for all todos in task
          if (tasks[i].todos![j]['done'] == true) {
            // check todos is completed
            count += 1;
          }
        }
      }
    }
    return count;
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
