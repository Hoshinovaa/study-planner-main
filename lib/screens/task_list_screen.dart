import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_task_screen.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  
  /// TAMBAH TASK
  Future<void> _goToAddTask() async {
    await Navigator.pushNamed(context, '/add-target');
  }

  /// UPDATE STATUS
  Future<void> updateStatus(
    String docId,
    String newStatus,
  ) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(docId)
        .update({
      'status': newStatus,
    });
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

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection('tasks')
          .where(
            'uid',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .orderBy('createdAt', descending: true)
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada tugas",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];

              final task =
                  doc.data() as Map<String, dynamic>;

              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _viewDetail(task),
                  child: TaskCard(
                    taskId: doc.id,
                    title: task["title"] ?? "-",
                    subtitle: task["course"] ?? "-",
                    deadline: task["deadline"] ?? "-",
                    lokasi: task["locationName"] ?? "-",
                    status: task["status"] ??
                        "BELUM DIKERJAKAN",

                    onStatusChange: (newStatus) async {
                      await updateStatus(
                        doc.id,
                        newStatus,
                      );
                    },

                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTargetScreen(
                            taskId: doc.id,
                            title: task["title"] ?? "",
                            matkul: task["course"] ?? "",
                            deadline: task["deadline"] ?? "",
                            lokasi: task["locationName"] ?? "",
                          ),
                        ),
                      );
                    },
                    
                    onDelete: () async {
                      await FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(doc.id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTask,
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}