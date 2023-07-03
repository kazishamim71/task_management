import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class Task {
  final String title;
  final String description;
  final DateTime deadline;

  Task({
    required this.title,
    required this.description,
    required this.deadline,
  });
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];

  void _addTask(Task task) {
    _tasks.add(task);
    setState(() {

    });
  }

  void _deleteTask(Task task) {
    _tasks.remove(task);
    setState(() {

    });
  }

  void _showAddTaskDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController dateField = TextEditingController();
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),

              TextField(
                controller: dateField,
                decoration: InputDecoration(
                  labelText: 'Select Date',
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100));
                  if (picked != null) {
                    setState(() {
                     selectedDate = picked;
                     dateField.value=TextEditingValue(text: '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}');
                    });
                  }

                }
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String title = titleController.text;
                String description = descriptionController.text;
                if (title.isNotEmpty &&
                    description.isNotEmpty &&
                    selectedDate != null) {
                  Task newTask = Task(
                    title: title,
                    description: description,
                    deadline: selectedDate!,
                  );
                  _addTask(newTask);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTaskDetailsBottomSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Description: ${task.description}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Deadline: ${task.deadline.day}-${task.deadline.month}-${task.deadline.year}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _deleteTask(task);
                  Navigator.of(context).pop();
                },
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Tasks'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          Task task = _tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(
                'Deadline: ${task.deadline.day}-${task.deadline.month}-${task.deadline.year}'),
            onTap: () => _showTaskDetailsBottomSheet(context, task),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
