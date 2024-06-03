import 'package:cloud_bucket/models/intent_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IntentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<IntentModel>> fetchActivities() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('activities').get();
      return querySnapshot.docs
          .map((doc) => IntentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Failed to fetch activities: $e');
      return [];
    }
  }
}
