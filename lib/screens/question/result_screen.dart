import 'package:flutter/material.dart';
import 'package:flutter_study_app/configs/themes/custom_text_styles.dart';
import 'package:flutter_study_app/controllers/question_paper/questions_controller.dart';
import 'package:flutter_study_app/controllers/question_paper/questions_controller_extension.dart';
import 'package:flutter_study_app/screens/question/answer_check_screen.dart';
import 'package:flutter_study_app/screens/question/question_number_card.dart';
import 'package:flutter_study_app/widgets/common/background_decoration.dart';
import 'package:flutter_study_app/widgets/common/custom_app_bar.dart';
import 'package:flutter_study_app/widgets/content_area.dart';
import 'package:flutter_study_app/widgets/questions/answer_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ResultScreen extends GetView<QuestionsController> {
  const ResultScreen({super.key});

  static const String routeName = "/resultscreen";

  @override
  Widget build(BuildContext context) {
    Color textColor =
        Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor;
    return Scaffold(
        body: BackgroundDecoration(
      child: Column(
        children: [
          CustomAppBar(
            title: controller.correctAnsweredQuestions,
            leadingWidget: const SizedBox(
              height: 80,
            ),
          ),
          Expanded(
            child: ContentArea(
              child: Column(
                children: [
                  SvgPicture.asset('assets/images/bulb.svg'),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 5),
                    child: Text('Congradulations',
                        style: headerText.copyWith(color: textColor)),
                  ),
                  Text(
                    'You have ${controller.points} points',
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'Tap below quesiton numbers to view correct answers',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                      child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Get.width ~/ 75,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (_, index) {
                      final question = controller.allQuestions[index];
                      AnswerStatus status = AnswerStatus.notanswered;
                      final selectedAnswer = question.selectedAnswer;
                      final correctAnswer = question.correctAnswer;
                      if (selectedAnswer == correctAnswer) {
                        status = AnswerStatus.correct;
                      } else if (selectedAnswer == null) {
                        status = AnswerStatus.wrong;
                      } else {
                        status = AnswerStatus.wrong;
                      }

                      return QuestionNumberCard(
                        index: index,
                        status: status,
                        onTap: () {
                          controller.jumpToQuestion(index, isGoBack: false);
                          Get.toNamed(AnswerCheckScreen.routeName);
                        },
                      );
                    },
                    itemCount: controller.allQuestions.length,
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
