import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// FUNGSI AMBIL DAFTAR BIDANG/MAPEL SECARA REAL-TIME DARI FIRESTORE
  Stream<QuerySnapshot> getTeachingSubjects() {
    return _firestore.collection('subjects').snapshots();
  }

  /// FUNGSI DAFTAR STUDENT (SUDAH DIPERBAIKI PASSWORD-NYA) 🚀
  Future<void> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String role,
    required String schoolLevel,
    required String schoolClass,
  }) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(), // ← Perbaikan: Sekarang password sudah dipasang aman!
    );

    String uid = userCredential.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      "uid": uid,
      "full_name": fullName.trim(),
      "email": email.trim(),
      "role": role,
      "school_level": schoolLevel.trim(),
      "school_class": int.tryParse(schoolClass.trim()) ?? schoolClass.trim(),
      "interest": "Belum ditentukan",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// FUNGSI DAFTAR MENTOR DENGAN JURUSAN, FAKULTAS & BIDANG AJAR
  Future<void> registerMentor({
    required String email,
    required String password,
    required String fullName,
    required String age,
    required String campus,
    required String faculty, 
    required String major,   
    required String teachingSubject, 
    required String district,
    required String semester,
    required String cvLink,
    required String transcriptLink,
    required String bio,
    required String reason,
  }) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    String uid = userCredential.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      "uid": uid,
      "full_name": fullName.trim(),
      "email": email.trim(),
      "role": "mentor",
      "age": int.tryParse(age.trim()) ?? age.trim(),
      "campus": campus.trim(),
      "faculty": faculty.trim(), 
      "major": major.trim(),     
      "teaching_subject": teachingSubject, 
      "district": district.trim(),
      "semester": int.tryParse(semester.trim()) ?? semester.trim(),
      "cv_link": cvLink.trim(),
      "transcript_link": transcriptLink.trim(),
      "bio": bio.trim(),
      "reason": reason.trim(),
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// FUNGSI MASUK (LOGIN)
  Future<DocumentSnapshot> loginUser({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    String uid = userCredential.user!.uid;
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

    return userDoc;
  }
}