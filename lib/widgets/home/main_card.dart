import 'package:easy_separator/easy_separator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzle/configs/configs.dart';
import 'package:quizzle/controllers/controllers.dart';
import 'package:quizzle/controllers/quiz_paper/quiz_papers_controller.dart';
import 'package:quizzle/widgets/widgets.dart';

class MainCard extends GetView<QuizPaperController> {
  const MainCard({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.RouteName,
    required this.imageUrl,
  }) : super(key: key);

  final id;
  final title;
  final description;
  final RouteName;
  final imageUrl;

  @override
  Widget build(BuildContext context) {
    const double _padding = 10.0;
    return Ink(
      decoration: BoxDecoration(
        borderRadius: UIParameters.cardBorderRadius,
        color: Theme.of(context).cardColor,
      ),
      child: InkWell(
        borderRadius: UIParameters.cardBorderRadius,
        onTap: () {
          controller.setParams(id);
          Get.toNamed(RouteName);
        },
        child: Padding(
            padding: const EdgeInsets.all(_padding),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: UIParameters.cardBorderRadius,
                      child: ColoredBox(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          child: SizedBox(
                            width: 65,
                            height: 65,
                            child: imageUrl == null || imageUrl!.isEmpty
                                ? null
                                : Image.asset(imageUrl),
                          )),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: cardTitleTs(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 15),
                          child: Text(description),
                        ),
                        if (id != '3')
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: EasySeparatedRow(
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(width: 15);
                              },
                              children: [
                                IconWithText(
                                    icon: Icon(Icons.help_outline_sharp,
                                        color: Colors.blue[700]),
                                    text: Text(
                                      '10 Tests',
                                      style: kDetailsTS.copyWith(
                                          color: Colors.blue[700]),
                                    )),
                              ],
                            ),
                          )
                      ],
                    ))
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
