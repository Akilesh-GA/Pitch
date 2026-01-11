import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch user stream
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  /// Fetch user once
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  /// ✅ Update profile fields (EXTENDED – old logic preserved)
  static Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? photoUrl,
    String? dob,      // yyyy-MM-dd
    String? phone,    // NEW
  }) async {
    final Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    if (dob != null) data['dob'] = dob;
    if (phone != null) data['phone'] = phone;

    if (data.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(data);
    }
  }
}
