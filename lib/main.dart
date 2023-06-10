import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/config.dart';
import 'package:cashor_app/screens/splash/splash_screen.dart';
import 'package:discord_logger/discord_logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cashor_app/config/constants.dart' as constants;

void main() async {
  // get storage initialization
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing the discord logger to log the errors from Appwrite SDK to my discord server
    DiscordLogger(
      channelId: constants.discordChannelId,
      botToken: constants.botToken,
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: !Config.isProduction,
      title: Config.appName,
      theme: ThemeData(
        scaffoldBackgroundColor: whiteColor,
        fontFamily: "Sora",
        textTheme: GoogleFonts.soraTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
