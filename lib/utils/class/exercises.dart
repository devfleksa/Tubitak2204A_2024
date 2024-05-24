import 'package:cloud_firestore/cloud_firestore.dart';

class Exercises {
  final String id;
  final String uid;
  final String name;
  final String description;
  final String imagePath;
  final String status;
  final String minAngle;
  final String reps;
  final List<String>? stats;

  const Exercises({
    required this.id,
    required this.uid,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.status,
    required this.minAngle,
    required this.reps,
    required this.stats,
  });

  static Exercises empty() => const Exercises(
        id: '',
        uid: '',
        name: '',
        description: '',
        imagePath: '',
        status: '',
        minAngle: '',
        reps: '',
        stats: [],
      );

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'status': status,
      'minAngle': minAngle,
      'reps': reps,
      'stats': stats,
    };
  }

  factory Exercises.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Exercises(
        id: document.id,
        uid: data['id'] ?? '',
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        imagePath: data['imagePath'] ?? '',
        status: data['status'] ?? '',
        minAngle: data['minAngle'] ?? '',
        reps: data['reps'] ?? '',
        stats: List<String>.from(data['stats'] as List<dynamic>? ?? []),
      );
    } else {
      return Exercises.empty();
    }
  }
}
