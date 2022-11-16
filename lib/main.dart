import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'blocs/generics/generic_bloc.dart';
import 'blocs/generics/generics_event.dart';
import 'gen/assets.gen.dart';
import 'models/item_model.dart';
import 'repositories/item_repository.dart';
import 'screens/main_page/main_page.dart';
import 'services/initializer.dart';
import 'services/locator.dart';
import 'services/navigation/navigation_service.dart';
import 'services/navigation/route_names.dart';
import 'services/navigation/router.dart';
import 'services/theme/theme_data.dart';
import 'widgets/responsive_wrapper.dart';

void main() async {
  await projectInitializer();
  runApp(const DiviApp());
}

class DiviApp extends StatelessWidget {
  const DiviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? widget) {
        return responsiveWrapperBuilder(context, widget!);
      },
      title: 'Divi Up',
      theme: themeDataBuilder(),
      home: MultiBlocProvider(
          providers: <
              BlocProvider<GenericBloc<dynamic, GenericBlocRepository<dynamic>>>>[
            BlocProvider<GenericBloc<ItemData, ItemRepository>>(
                create: (BuildContext context) =>
                    GenericBloc<ItemData, ItemRepository>(
                        repository: ItemRepository())..add(LoadingGenericData()))
          ],
          child: const OnBoardingPage()),
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigationKey,
      onGenerateRoute: generateRoute,
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final GlobalKey<IntroductionScreenState> introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(BuildContext context) {
    navigationService.navigateTo(HomeRoute);
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(Assets.images.profile.path, width: width);
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle bodyStyle = TextStyle(fontSize: 19.0);

    const PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('flutter.png', 100),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            "Let's go right away!",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: 'Fractional shares',
          body:
          'Instead of having to buy an entire share, invest any amount you want.',
          image: _buildImage('img1.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Learn as you go',
          body:
          'Download the Stockpile app and master the market with our mini-lesson.',
          image: _buildImage('img2.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Kids and teens',
          body:
          'Kids and teens can track their stocks 24/7 and place trades that you approve.',
          image: _buildImage('img3.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Full Screen Page',
          body:
          'Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.',
          image: _buildFullscreenImage(),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          title: 'Another title page',
          body: 'Another beautiful body text for this example onboarding',
          image: _buildImage('img2.jpg'),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'FooButton',
              style: TextStyle(color: Colors.white),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Title of last page - reversed',
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Click on ', style: bodyStyle),
              Icon(Icons.edit),
              Text(' to edit a post', style: bodyStyle),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('img1.jpg'),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}