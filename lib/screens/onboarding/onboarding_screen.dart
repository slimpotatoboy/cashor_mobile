import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/screens/auth/login/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void _onIntroEnd(context) {
    Get.to(() => const LoginScreen());
  }

  Widget _buildImage(String assetName, [double width = 250]) {
    return SvgPicture.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 18.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 26.0,
      ),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      globalFooter: Container(
        margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: TextButton.styleFrom(backgroundColor: primaryColor),
          child: const Text(
            'Let\'s go right away!',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Welcome to Cashor",
          body:
              "Streamline your business operations and take control of your financial management with Cashor",
          image: _buildImage('welcome.svg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Efficient Order Processing",
          body:
              "Simplify order management, track progress, and ensure timely delivery with Cashor's integrated solution.",
          image: _buildImage('order.svg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Optimize Product Management",
          body:
              "Manage inventory, pricing, and stock levels effortlessly to meet customer demand and drive sales.",
          image: _buildImage('product.svg'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: false,
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
