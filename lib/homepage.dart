import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practical_exam/addpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  bool forLoading = true;
  List forItem = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Todos'),
      ),
      body: Visibility(
          visible: forLoading,
          replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: ListView.builder(
              itemCount: forItem.length,
              itemBuilder: (context, index){
                final item = forItem[index] as Map;
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                      onSelected: (value){
                        if(value == 'edit'){
                          navigateToEditPage(item);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                        ];
                      }
                  ),
                );
              },
            ),
          ),

          child: const Center(child: CircularProgressIndicator(),
          ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: navigateToAddPage,
          child: const Icon(Icons.add),),
    );
  }

  Future<void> fetchTodo() async {
    const url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri =  Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        forItem = result;
      });
    }
    setState(() {
      forLoading = false;
    });
  }

  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(
      builder: (context) =>  const AddPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      forLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) =>  AddPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      forLoading = true;
    });
    fetchTodo();
  }
}
