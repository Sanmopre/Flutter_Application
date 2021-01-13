import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/chat_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildErrorPage(String message) {
    return Scaffold(
      body: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildLoadingPage() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildTodoListPage(QuerySnapshot snapshot) {
    final todos = FirebaseFirestore.instance.collection('todos');
    final docs = snapshot.docs;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF229126),
        title: Text('Task list:'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat_bubble),
            onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Chat_screen(),
                  ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, int index) {
                final item = docs[index];
                return ListTile(
                  title: Text(
                    item['what'],
                    style: TextStyle(
                      decoration: item['done']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: Checkbox(
                    value: item['done'],
                    onChanged: (newValue) {
                      todos.doc(item.id).update({'done': newValue});
                    },
                  ),
                  onTap: () {
                    todos.doc(item.id).update({'done': !item['done']});
                  },
                  onLongPress: () {
                    todos.doc(item.id).delete();
                  },
                );
              },
            ),
          ),
          Material(
            elevation: 16,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      todos.add({
                        'what': _controller.text,
                        'done': false,
                        'date': DateTime.now(),
                      });
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todos = FirebaseFirestore.instance.collection('todos');
    return StreamBuilder(
      stream: todos.orderBy('date').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorPage(snapshot.error.toString());
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoadingPage();
          case ConnectionState.active:
            return _buildTodoListPage(snapshot.data);
          default: // ConnectionState.none // ConnectionState.done
            return _buildErrorPage("unreachable!!!");
        }
      },
    );
  }
}
