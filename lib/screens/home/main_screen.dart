import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:quizzle/configs/configs.dart';
import 'package:quizzle/controllers/controllers.dart';
import 'package:quizzle/widgets/widgets.dart';

import 'custom_drawer.dart';

class MainScreen extends GetView<MyDrawerController> {
  const MainScreen({Key? key}) : super(key: key);

  static const String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    QuizPaperController _quizePprContoller = Get.find();

    List<Map<String, dynamic>> mainCardList = [
      {
        'id': '1',
        'title': 'Grammar Tests',
        'description':
            'You can improve your grammar knowledge here just solve tests',
        'RouteName': '/home',
        'imageUrl': 'assets/images/grammar.png',
      },
      {
        'id': '2',
        'title': 'Vocabulary Tests',
        'description':
            'You can improve your vocabulary knowledge here just solve tests',
        'RouteName': '/home',
        'imageUrl': 'assets/images/vocabulary.png',
      },
      {
        'id': '3',
        'title': 'Dictionary',
        'description':
            'You can search any vocabulary as you wish just type the word',
        'RouteName': '/dictionary',
        'imageUrl': 'assets/images/dictionary.png',
      }
    ];

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
                    padding: const EdgeInsets.all(kMobileScreenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(-10, 0),
                          child: CircularButton(
                            child: const Icon(AppIcons.menuleft),
                            onTap: controller.toggleDrawer,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(AppIcons.peace),
                              Builder(
                                builder: (_) {
                                  final AuthController _auth = Get.find();
                                  final user = _auth.getUser();
                                  String _label = '  Hello mate';
                                  if (user != null) {
                                    _label = '  Hello ${user.displayName}';
                                  }
                                  return Text(
                                    _label,
                                    style: kDetailsTS.copyWith(
                                      color: kOnSurfaceTextColor,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Welcome to QuizWhiz',
                          style: kHeaderTS,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ContentArea(
                        addPadding: false,
                        child: ListView.separated(
                          padding: UIParameters.screenPadding,
                          shrinkWrap: true,
                          itemCount: mainCardList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final cardData = mainCardList[index];
                            return MainCard(
                              id: cardData['id'],
                              title: cardData['title'],
                              description: cardData['description'],
                              RouteName: cardData['RouteName'],
                              imageUrl: cardData['imageUrl'],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
