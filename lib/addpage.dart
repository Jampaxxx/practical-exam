import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  final Map? todo;
  const AddPage({
    super.key,
    this.todo,
  });

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo !=null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];

      titleController.text = title;
      descController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Task' : 'Add Task',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        key: formKey,
        children: [
          TextFormField(
            controller: titleController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: descController,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed:isEdit ? updateData : submitData,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  isEdit? 'Update' : 'Add Task',
                ),
              )
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if(todo == null){
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final desc = descController.text;
    final body = {
      "title": title,
      "description": desc,
      "is_complete": false,
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if(response.statusCode == 200){
      showSuccessMessage('Update Success');
    } else {
      showErrorMessage('Update Failed');
    }
  }

  Future <void> submitData() async{
    final title = titleController.text;
    final desc = descController.text;
    final body = {
      "title": title,
      "description": desc,
      "is_complete": false,
    };
    const url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if(response.statusCode == 201){
      titleController.text = '';
      descController.text = '';
      showSuccessMessage('Task Creation Success');
    } else {
      showErrorMessage('Task Creation Failed');
    }
  }
  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMessage(String message){
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
