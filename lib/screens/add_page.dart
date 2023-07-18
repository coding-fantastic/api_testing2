// import 'dart:convert';

import 'package:api_testing2/services/todo_service.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    // check if someone is coming to this page with edit button
    if (widget.todo != null) {
      isEdit = true;
      // prefill Edit form
      final title = todo?['title'];
      final description = todo?['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
        ),
      ),
      // pro of listiveiew it will scrollable
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                isEdit ? 'Update' : 'Submit',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call updated without todo data ');
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      'title': title,
      'description': description,
      'is_completed': false,
    };

    // submit update data to the server
    final isSuccess = await TodoService.updateTodo(id, body);

    // show success or fail message based on status
    if (isSuccess) {
      showSuccessMessage('Update success');
    } else {
      showErrorMessage('Update failed');
    }
  }

  // form handling
  Future<void> submitData() async {
    // get the data from form

    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      'title': title,
      'description': description,
      'is_completed': true,
    };

    // submit data to the server

    final isSuccess = await TodoService.addTodo(body);

    // show success or fail message based on status
    if (isSuccess) {
      // reset the form
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage('Creation success');
    } else {
      showErrorMessage('Creation Failed');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
