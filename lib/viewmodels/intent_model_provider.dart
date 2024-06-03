import 'dart:io';

import 'package:cloud_bucket/models/intent_model.dart';
import 'package:cloud_bucket/repositories/intent_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class IntentModelProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isFileUpLoading = false;
  bool isTextOrFileFilled = true;
  bool _textToUploadFilled = false;
  bool _fileToUploadFilled = false;
  double progress = 0.0;
  String? downloadedURL;
  IntentModel? activity;
  FilePickerResult? result;
  TextEditingController textController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<IntentModel>> fetchActivitiesRepo() async {
    try {
      return IntentRepository().fetchActivities();
    } catch (e) {
      debugPrint('Failed to fetch activities: $e');
      return [];
    }
  }

  // two variants are used here
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

  Future<String> uploadFile(File file, String path) async {
    try {
      var reference = _storage.ref().child(path);
      var task = reference.putFile(file);
      task.snapshotEvents.listen((event) {
        debugPrint('event: $event');
        if (event.state == TaskState.running) {
          isLoading = true;
          isFileUpLoading = true;
          progress = ((event.bytesTransferred / event.totalBytes) * 100)
              .floorToDouble();
          // debugPrint('progress: $progress');
        } else if (event.state == TaskState.success) {
          resetData();
        }
        notifyListeners();
      }).onError((error) {
        return error.toString();
      });
      return await task.snapshot.ref.getDownloadURL();
    } catch (e) {
      return 'Failed to upload file: ${e.toString()}';
    }
  }

  Future<void> openFiles() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
      allowMultiple: true,
    );
  }

  Future uploadFiles() async {
    List<String> imageUrls = [];
    List<String> pdfUrls = [];

    if (textController.text.isNotEmpty) {
      _textToUploadFilled = true;
    }
    if (result != null) {
      _fileToUploadFilled = true;
    }

    isLoading = true;
    notifyListeners();

    if (_textToUploadFilled || _fileToUploadFilled) {
      isTextOrFileFilled = true;
    } else {
      isTextOrFileFilled = false;
    }
    if (isTextOrFileFilled) {
      if (_fileToUploadFilled) {
        for (var file in result!.files) {
          File uploadCurrentFile = File(file.path!);
          String downloadUrl =
              await uploadFile(uploadCurrentFile, 'uploads/${file.name}');
          if (file.extension == 'jpg' || file.extension == 'png') {
            imageUrls.add(downloadUrl);
          } else if (file.extension == 'pdf') {
            pdfUrls.add(downloadUrl);
          }
        }
      }
      // create the data object to be uploaded into firebase.
      activity = IntentModel(
        id: '',
        text: textController.text,
        imageUrls: imageUrls,
        pdfUrls: pdfUrls,
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection('activities')
          .add(activity!.toMap())
          .then((value) => {
                debugPrint(value.id),
                resetData(),
                notifyListeners(),
              })
          .onError((error, stackTrace) => {
                isLoading = false,
                notifyListeners(),
                debugPrint('Failed to upload file: ${error.toString()}')
              });
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetData() {
    _textToUploadFilled = false;
    _fileToUploadFilled = false;
    isFileUpLoading = false;
    isLoading = false;
    result = null;
    activity = null;
    textController.text = '';
  }
}
