import 'package:cashor_app/components/navigation_home.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();

    /// if the app contains token then it will navigate to [NavigationHomeScreen] else [LoginScreen]
    Future.delayed(const Duration(milliseconds: 3000), () {
      Get.off(
        () => storage.hasData('userId') && storage.hasData('businessId')
            ? const NavigationHomeScreen()
            : const OnboardingScreen(),
        duration: const Duration(milliseconds: 500),
        transition: Transition.downToUp,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: whiteColor,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "🇳🇵",
                            style: TextStyle(fontSize: 50),
                          ),
                          Text(
                            "Made with ❤️ and",
                            style: allRedTextStyle,
                          ),
                        ],
                      ),
                    ),
                    // Appwrite Logo
                    SvgPicture.asset(
                      'assets/images/appwrite-pink.svg',
                      width: 80,
                    ),
                  ],
                ),
                Hero(
                  tag: "hero-logo",
                  child: Image.asset(
                    'assets/images/logo11.png',
                    width: 300,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
