import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  List<Map<String, dynamic>> tasks = [
    {
      "title": "Aplikasi Perangkat Bergerak",
      "subtitle": "Progres Tubes",
      "deadline": "18 April 2026",
      "status": "DALAM PENGERJAAN",
    },
    {
      "title": "Sistem Cerdas IoT",
      "subtitle": "Tugas Kelompok",
      "deadline": "20 April 2026",
      "status": "BELUM DIKERJAKAN",
    },
  ];

  /// TAMBAH TASK
  void _goToAddTask() async {
    final result = await Navigator.pushNamed(context, '/add-target');

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        tasks.add(result);
      });
    }
  }

  /// DELETE TASK
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  /// EDIT TASK
  void _editTask(int index) async {
    final result = await Navigator.pushNamed(context, '/add-target');

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        tasks[index] = result;
      });
    }
  }

  /// DETAIL TASK
  void _viewDetail(Map<String, dynamic> task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),

      /// APPBAR
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF6A0DAD),
        title: const Text(
          "Daftar Tugas Kuliah",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// LIST TASK
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => _viewDetail(task),
              child: TaskCard(
                title: task["title"] ?? "-",
                subtitle: task["subtitle"] ?? "-",
                deadline: task["deadline"] ?? "-",
                status: task["status"] ?? "BELUM DIKERJAKAN",

                /// FIX UTAMA (UPDATE STATUS)
                onStatusChange: (newStatus) {
                  setState(() {
                    tasks[index]["status"] = newStatus;
                  });
                },

                onEdit: () => _editTask(index),
                onDelete: () => _deleteTask(index),
              ),
            ),
          );
        },
      ),

      /// FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTask,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}