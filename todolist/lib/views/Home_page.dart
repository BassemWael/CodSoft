import 'package:app/components/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:app/models/task.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key? key});
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
    // Load tasks from SharedPreferences when the app starts
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
      // Initialize tasklist with an empty list if there are no saved tasks
      tasklist = [];
    }
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = json.encode(tasklist);
    await prefs.setString('tasks', taskListJson);
  }

  void addTask() {
    // Get the task name and description from the text fields.
    String taskName = textController.text;
    String taskDescription = textController2.text;

    if (taskName.isEmpty) {
      setState(() {
        errorMessage = "Task name cannot be empty";
      });
      return; // Don't proceed further if the task name is empty
    }

    // Create a new task object with the checkbox state set to false (unchecked).
    Tasks newTask =
        Tasks(name: taskName, description: taskDescription, ischecked: false);

    // Add the new task to the list of tasks.
    tasklist.add(newTask);

    // Save the updated list of tasks.
    saveTasks();

    // Clear text fields and error message
    textController.clear();
    textController2.clear();
    setState(() {
      errorMessage = "";
    });
  }

  void onTaskCheckboxChanged(bool isChecked, Tasks task) {
    // Update the task's checkbox state
    task.ischecked = isChecked;

    // Save the updated list of tasks when a task's checkbox changes
    saveTasks();

    // Refresh the list of tasks.
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
              key: UniqueKey(), // Ensure each item has a unique key.
              onDismissed: (direction) {
                // Remove the task from the list when it's dismissed.
                setState(() {
                  tasklist.removeAt(index);
                });
                // Save the updated list of tasks.
                saveTasks();
              },
              background: Container(
                color: Colors
                    .orange, // Customize the background color when swiping.
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Task(
                task: tasklist[index],
                onCheckboxChanged: (isChecked) {
                  // Pass the callback function to the Task widget
                  onTaskCheckboxChanged(isChecked, tasklist[index]);
                },
                onTaskEdit: (editedTask) {
                  // Handle task editing here, and save the updated tasks
                  saveTasks();
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 239, 139, 51),
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
                          style: TextStyle(
                              color: Colors.red)), // Display error message
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
                        // Add the new task and refresh the list.
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
      onTaskEdit: onTaskEdit, // Pass the onTaskEdit callback here
    ));
  }
  return itemslist;
}
