import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTask({
    required String title,
    required String course,
    required String deadline,
    required double progress,
    required String locationName,
    String? address,
    double? lat,
    double? lng,
  }) async {
    await _db.collection('tasks').add({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'title': title,
      'course': course,
      'deadline': deadline,
      'status': 'BELUM DIKERJAKAN',
      'progress': progress,
      'address': address,
      'lat': lat,
      'lng': lng,
      'createdAt': Timestamp.now(),
    });
  }
}