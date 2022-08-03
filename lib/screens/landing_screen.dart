import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../widgets/intro_screen_widget/introduction_screen.dart';


class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  IntroductionScreen(
        initialPage: 1,
        showDoneButton: false,
        showNextButton: true,
        showSkipButton: false,
        showBackButton: true,

        next: ElevatedButton(onPressed: (){}, child: const Text('Next')),
        back: ElevatedButton(onPressed: (){}, child: const Text('Back')),

        pages: [
          PageViewModel(
              title:  'Page 1',
              body: 'lalal'
          ),

          PageViewModel(
              title:  'Page 2',
              body: 'lala'
          ),

          PageViewModel(
              title:  'Page 3',
              body: 'lala'
          ),


        ],
      ),
    );
  }
}
