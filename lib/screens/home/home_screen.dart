import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:quizzle/configs/configs.dart';
import 'package:quizzle/controllers/controllers.dart';
import 'package:quizzle/widgets/widgets.dart';

import 'custom_drawer.dart';

class HomeScreen extends GetView<MyDrawerController> {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    QuizPaperController _quizePprContoller = Get.find();
    String id = _quizePprContoller.getParams();

    return Scaffold(
        body: GetBuilder<MyDrawerController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        borderRadius: 50.0,
        showShadow: true,
        angle: 0.0,
        style: DrawerStyle.DefaultStyle,
        menuScreen: const CustomDrawer(),
        backgroundColor: Colors.white.withOpacity(0.5),
        slideWidth: MediaQuery.of(context).size.width * 0.4,
        mainScreen: Container(
          decoration: BoxDecoration(gradient: mainGradient(context)),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -10),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 30, // Increased icon size to 30
                          onPressed: () {
                            Get.offNamed(
                                '/main'); // Navigates to the route with routeName '/main'
                          },
                        ),
                      ),
                      const Text('Take Your Quiz', style: kHeaderTS),
                      // Added spacer to align the back button to the right
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ContentArea(
                      addPadding: false,
                      child: Obx(
                        () => LiquidPullToRefresh(
                          height: 150,
                          springAnimationDurationInMilliseconds: 500,
                          //backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          color: Colors.amber,
                          onRefresh: () async {
                            _quizePprContoller.getAllPapers();
                          },
                          child: ListView.separated(
                            padding: UIParameters.screenPadding,
                            shrinkWrap: true,
                            itemCount: _quizePprContoller.allPapers.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (id == '1') {
                                if (_quizePprContoller.allPapers[index].id
                                        .startsWith('p') ||
                                    _quizePprContoller.allPapers[index].id
                                        .startsWith('P')) {
                                  return QuizPaperCard(
                                    model: _quizePprContoller.allPapers[index],
                                  );
                                }
                              } else if (id == '2') {
                                if (_quizePprContoller.allPapers[index].id
                                        .startsWith('v') ||
                                    _quizePprContoller.allPapers[index].id
                                        .startsWith('V')) {
                                  return QuizPaperCard(
                                    model: _quizePprContoller.allPapers[index],
                                  );
                                }
                              }
                              return SizedBox.shrink();
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 20,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
