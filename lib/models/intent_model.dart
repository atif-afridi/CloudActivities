import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class IntentModel extends Equatable {
  String id;
  String text;
  List<String> imageUrls;
  List<String> pdfUrls;
  DateTime? timestamp;

  IntentModel({
    required this.id,
    required this.text,
    required this.imageUrls,
    required this.pdfUrls,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'imageUrls': imageUrls,
      'pdfUrls': pdfUrls,
      'timestamp': timestamp,
    };
  }

  factory IntentModel.fromMap(Map<String, dynamic> map) {
    return IntentModel(
      id: map['id'] as String,
      text: map['text'] as String,
      imageUrls: List<String>.from(map['imageUrls']),
      pdfUrls: List<String>.from(map['pdfUrls']),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        imageUrls,
        pdfUrls,
        timestamp,
      ];
}
