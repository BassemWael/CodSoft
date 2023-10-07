import 'package:my_todo_list/components/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_list/models/task.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final GlobalKey<_HomePageState> homePageKey = GlobalKey<_HomePageState>();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  final textController2 = TextEditingController();
  String errorMessage = "";
  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> taskList = json.decode(tasksJson);

      setState(() {
        tasklist = taskList.map((taskMap) => Tasks.fromJson(taskMap)).toList();
      });
    } else {
      tasklist = [];
    }
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = json.encode(tasklist);
    await prefs.setString('tasks', taskListJson);
  }

  void addTask() {
    String taskName = textController.text;
    String taskDescription = textController2.text;

    if (taskName.isEmpty) {
      setState(() {
        errorMessage = "Task name cannot be empty";
      });
      return;
    }
    Tasks newTask =
        Tasks(name: taskName, description: taskDescription, ischecked: false);
    tasklist.add(newTask);

    saveTasks();

    textController.clear();
    textController2.clear();
    setState(() {
      errorMessage = "";
    });
  }

  void onTaskCheckboxChanged(bool isChecked, Tasks task) {
    // Update the task's checkbox state
    task.ischecked = isChecked;

    saveTasks();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xffFFFFFF),
        elevation: 0,
        title: const Row(
          children: [
            Text(
              'To Do ',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              'List',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 239, 139, 51)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView.builder(
          itemCount: tasklist.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  tasklist.removeAt(index);
                });
                saveTasks();
              },
              background: Container(
                color: Colors.orange,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Task(
                task: tasklist[index],
                onCheckboxChanged: (isChecked) {
                  onTaskCheckboxChanged(isChecked, tasklist[index]);
                },
                onTaskEdit: (editedTask) {
                  saveTasks();
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 239, 139, 51),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: textController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: textController2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                          ),
                        ),
                      ),
                      Text(errorMessage,
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        addTask();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}

List<Widget> getList(List<Tasks> tasklist, Function(bool) onCheckboxChanged,
    Function(Tasks) onTaskEdit) {
  List<Widget> itemslist = [];
  for (int i = 0; i < tasklist.length; i++) {
    itemslist.add(Task(
      task: tasklist[i],
      onCheckboxChanged: onCheckboxChanged,
      onTaskEdit: onTaskEdit,
    ));
  }
  return itemslist;
}
