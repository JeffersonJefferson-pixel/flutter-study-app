import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_study_app/configs/themes/app_dark_theme.dart';
import 'package:flutter_study_app/configs/themes/custom_text_styles.dart';
import 'package:flutter_study_app/configs/themes/ui_parameteres.dart';
import 'package:flutter_study_app/models/question_paper_model.dart';
import 'package:get/get.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({Key? key, required this.model}) : super(key: key);

  final QuestionPaperModel model;

  @override
  Widget build(BuildContext context) {
    const double _padding = 10.0;
    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ColoredBox(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    child: SizedBox(
                        height: Get.width * 0.15,
                        width: Get.width * 0.15,
                        child: CachedNetworkImage(
                          imageUrl: model.imageUrl!,
                          placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/app_splash_logo.png"),
                        )),
                  )),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.title, style: cardTitles(context)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(model.description),
                    ),
                    Row()
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
