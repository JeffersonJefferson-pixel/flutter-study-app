import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_study_app/firebase_ref/loading_start.dart';
import 'package:flutter_study_app/firebase_ref/references.dart';
import 'package:flutter_study_app/models/question_paper_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataUploader extends GetxController {
  @override
  void onReady() {
    uploadData();
    super.onReady();
  }

  // turn into observable
  final loadingStatus = LoadingStatus.loading.obs;

  Future<void> uploadData() async {
    loadingStatus.value = LoadingStatus.loading;

    final fireStore = FirebaseFirestore.instance;
    final manifestContent = await DefaultAssetBundle.of(Get.context!)
        .loadString("AssetManifest.json");
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // load json file and read path
    final papersInAssets = manifestMap.keys
        .where((path) =>
            path.startsWith("assets/DB/papers") && path.contains(".json"))
        .toList();

    // load each file content
    List<QuestionPaperModel> questionPapers = [];
    for (var paper in papersInAssets) {
      String stringPaperContent = await rootBundle.loadString(paper);
      // convert to model
      questionPapers
          .add(QuestionPaperModel.fromJson(json.decode(stringPaperContent)));
    }

    // upload data in batch
    var batch = fireStore.batch();

    for (var paper in questionPapers) {
      DocumentReference paperRef = questionPaperRF.doc(paper.id);
      batch.set(paperRef, {
        "title": paper.title,
        "image_url": paper.imageUrl,
        "description": paper.description,
        "time_seconds": paper.timeSeconds,
        "questions_count": paper.questions == null ? 0 : paper.questions!.length
      });

      for (var question in paper.questions!) {
        DocumentReference questionRef =
            questionRF(paperRef: paperRef, questionId: question.id);
        batch.set(questionRef, {
          "question": question.question,
          "correct_answer": question.correctAnswer
        });

        for (var answer in question.answers) {
          DocumentReference answerRef =
              answerRF(questionRef: questionRef, answerId: answer.identifier);
          batch.set(answerRef,
              {"identifier": answer.identifier, "answer": answer.answer});
        }
      }
    }

    await batch.commit();

    loadingStatus.value = LoadingStatus.completed;
  }
}
