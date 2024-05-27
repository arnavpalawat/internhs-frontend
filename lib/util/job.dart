import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String? id;
  final String companyName;
  final String jobTitle;
  final int prestige;
  final String field;

  Job(
    this.id, {
    required this.companyName,
    required this.prestige,
    required this.jobTitle,
    required this.field,
  });
  factory Job.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Job(
      doc.id,
      companyName: data['companyName'],
      jobTitle: data['jobTitle'],
      prestige: data['prestige'],
      field: data['field'],
    );
  }
  // Convert a Job object into a map object
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'companyName': companyName,
  //     'jobTitle': jobTitle,
  //     'prestige': prestige,
  //     'field': field,
  //   };
  // }
  //
  // Future<void> addJob() async {
  //   final FirebaseFirestore db = FirebaseFirestore.instance;
  //   DocumentReference docRef = db.collection("jobs").doc();
  //   String jobId = docRef.id;
  //   id = jobId;
  //   try {
  //     await docRef.set(toMap());
  //     if (kDebugMode) {
  //       print('Job added successfully');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error adding job: $e');
  //     }
  //   }
  // }
}
