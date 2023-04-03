import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final fireStore = FirebaseFirestore.instance;
final questionPaperRF = fireStore.collection('questionPapers');

// sub collection need reference of parent collection
DocumentReference questionRF(
        {required DocumentReference paperRef, required String questionId}) =>
    paperRef.collection("questions").doc(questionId);

DocumentReference answerRF(
        {required DocumentReference questionRef, String? answerId}) =>
    questionRef.collection("answers").doc(answerId);

Reference get firebaseStorage => FirebaseStorage.instance.ref();
