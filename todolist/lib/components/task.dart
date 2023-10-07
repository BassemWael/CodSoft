import 'package:flutter/material.dart';
import 'package:my_todo_list/models/task.dart';

class Task extends StatefulWidget {
  const Task({
    Key? key,
    required this.task,
    required this.onCheckboxChanged,
    required this.onTaskEdit,
  }) : super(key: key);

  final Tasks task;
  final Function(bool) onCheckboxChanged;
  final Function(Tasks) onTaskEdit;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final textController = TextEditingController();
  final textController2 = TextEditingController();
  bool isChecked = false; // Separate state for the checkbox
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    // Initialize the local checkbox state from the task object
    isChecked = widget.task.ischecked;
    textController.text = widget.task.name;
    textController2.text = widget.task.description;
  }

  void editTask() {
    // Get the task name and description from the text fields.
    String taskName = textController.text;
    String taskDescription = textController2.text;

    if (taskName.isEmpty) {
      setState(() {
        errorMessage = "Task name cannot be empty";
      });
      return; // Don't proceed further if the task name is empty
    }

    // Update only the task properties, not the checkbox state
    widget.task.name = taskName;
    widget.task.description = taskDescription;

    // Call the callback to notify the parent about the task edit
    widget.onTaskEdit(widget.task);

    // Refresh the list of tasks and clear the error message
    setState(() {
      errorMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(255, 254, 194, 141),
            ),
            width: double.infinity,
            child: Row(children: [
              Checkbox(
                value: isChecked,
                onChanged: (newValue) {
                  setState(() {
                    isChecked = newValue ?? false;
                    // Update the task's checkbox state
                    widget.task.ischecked = isChecked;
                    // Call the callback to notify the parent
                    widget.onCheckboxChanged(isChecked);
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.task.name,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18)),
                    Text(widget.task.description,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14))
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
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
                                style: const TextStyle(
                                    color:
                                        Colors.red)), // Display error message
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              // Update the task and refresh the list.
                              editTask();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
