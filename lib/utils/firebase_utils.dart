import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches user data as a stream
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  /// Fetches user data once
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }
}
