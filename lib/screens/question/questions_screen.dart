import 'package:flutter/material.dart';
import 'package:flutter_study_app/configs/themes/custom_text_styles.dart';
import 'package:flutter_study_app/controllers/question_paper/questions_controller.dart';
import 'package:flutter_study_app/firebase_ref/loading_status.dart';
import 'package:flutter_study_app/widgets/common/background_decoration.dart';
import 'package:flutter_study_app/widgets/common/question_placeholder.dart';
import 'package:flutter_study_app/widgets/content_area.dart';
import 'package:flutter_study_app/widgets/questions/answer_card.dart';
import 'package:get/get.dart';

class QuestionsScreen extends GetView<QuestionsController> {
  const QuestionsScreen({super.key});

  static const String routeName = "/questions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundDecoration(
        child: Obx(
          () => Column(
            children: [
              if (controller.loadingStatus.value == LoadingStatus.loading)
                const Expanded(
                  child: ContentArea(
                    child: QuestionScreenPlaceholder(),
                  ),
                ),
              if (controller.loadingStatus.value == LoadingStatus.completed)
                Expanded(
                    child: ContentArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        Text(
                          controller.currentQuestion.value!.question,
                          style: questionTS,
                        ),
                        GetBuilder<QuestionsController>(builder: (context) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: 25),
                            itemBuilder: (BuildContext context, int index) {
                              final answer = controller
                                  .currentQuestion.value!.answers[index];
                              return AnswerCard(
                                answer: '${answer.identifier}.${answer.answer}',
                                onTap: () {
                                  controller.selectAnswer(answer.identifier);
                                },
                                isSelected: answer.identifier ==
                                    controller
                                        .currentQuestion.value!.selectedAnswer,
                              );
                            },
                            itemCount: controller
                                .currentQuestion.value!.answers.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ))
            ],
          ),
        ),
      ),
    );
  }
}
