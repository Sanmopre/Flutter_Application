import 'package:flutter/material.dart';

class Chat_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team chat"),
                actions: [
          IconButton(
            icon: Icon(Icons.check_box_outline_blank_outlined),
            onPressed: () {
                Navigator.of(context).pop();
            },
          ),
        ],
        ),
    );
  }
}