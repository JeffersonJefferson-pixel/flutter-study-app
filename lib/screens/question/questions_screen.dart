import 'package:flutter/material.dart';
import 'package:flutter_study_app/configs/themes/app_colors.dart';
import 'package:flutter_study_app/configs/themes/custom_text_styles.dart';
import 'package:flutter_study_app/configs/themes/ui_parameteres.dart';
import 'package:flutter_study_app/controllers/question_paper/questions_controller.dart';
import 'package:flutter_study_app/firebase_ref/loading_status.dart';
import 'package:flutter_study_app/screens/question/test_overview_screen.dart';
import 'package:flutter_study_app/widgets/common/background_decoration.dart';
import 'package:flutter_study_app/widgets/common/custom_app_bar.dart';
import 'package:flutter_study_app/widgets/common/main_button.dart';
import 'package:flutter_study_app/widgets/common/question_placeholder.dart';
import 'package:flutter_study_app/widgets/content_area.dart';
import 'package:flutter_study_app/widgets/questions/answer_card.dart';
import 'package:flutter_study_app/widgets/questions/countdown_timer.dart';
import 'package:get/get.dart';

class QuestionsScreen extends GetView<QuestionsController> {
  const QuestionsScreen({super.key});

  static const String routeName = "/questions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        leadingWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: const ShapeDecoration(
            shape: StadiumBorder(
              side: BorderSide(
                color: onSurfaceTextColor,
                width: 2,
              ),
            ),
          ),
          child: Obx(
            () => CountdownTimer(
              time: controller.time.value,
              color: onSurfaceTextColor,
            ),
          ),
        ),
        showActionIcon: true,
        titleWidget: Obx(
          () => Text(
            'Q. ${(controller.questionIndex.value + 1).toString().padLeft(2, '0')}',
            style: appBarTS,
          ),
        ),
      ),
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
                        GetBuilder<QuestionsController>(
                            id: 'answers_list',
                            builder: (context) {
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top: 25),
                                itemBuilder: (BuildContext context, int index) {
                                  final answer = controller
                                      .currentQuestion.value!.answers[index];
                                  return AnswerCard(
                                    answer:
                                        '${answer.identifier}.${answer.answer}',
                                    onTap: () {
                                      controller
                                          .selectAnswer(answer.identifier);
                                    },
                                    isSelected: answer.identifier ==
                                        controller.currentQuestion.value!
                                            .selectedAnswer,
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
                )),
              ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: UIParameters.mobileScreenPadding,
                  child: Row(
                    children: [
                      Visibility(
                        visible: !(controller.isFirstQuestion),
                        child: SizedBox(
                          width: 55,
                          height: 55,
                          child: MainButton(
                            onTap: () {
                              controller.prevQuestion();
                            },
                            color: Get.isDarkMode
                                ? onSurfaceTextColor
                                : Theme.of(context).primaryColor,
                            child: const Icon(Icons.arrow_back_ios_new),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Visibility(
                            visible: controller.loadingStatus.value ==
                                LoadingStatus.completed,
                            child: MainButton(
                              onTap: () {
                                controller.isLastQuestion
                                    ? Get.toNamed(TestOverviewScreen.routeName)
                                    : controller.nextQuestion();
                              },
                              title: controller.isLastQuestion
                                  ? 'Complete'
                                  : 'Next',
                            )),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
