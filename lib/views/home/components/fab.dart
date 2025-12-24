import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/task_view.dart';

class Fab extends StatefulWidget {
  const Fab({super.key});

  @override
  State<Fab> createState() => _FabState();
}

class _FabState extends State<Fab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF9A6BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 14, offset: Offset(0, 6)),
        ],
      ),
      child: RawMaterialButton(
        shape: const CircleBorder(),
        onPressed: () {
          // Add task action
          Navigator.push(context, CupertinoPageRoute(builder: (_)=> const TaskView(titleTaskController: null, descriptionTaskController: null,),),);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}