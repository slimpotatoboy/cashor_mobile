import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/list_button.dart';
import 'package:cashor_app/components/webview_widget.dart';
import 'package:cashor_app/config/config.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/splash/splash_screen.dart';
import 'package:cashor_app/screens/src/manage_people/views/manage_people_screen.dart';
import 'package:cashor_app/screens/src/more/business_settings/views/business_settings_screen.dart';
import 'package:cashor_app/screens/src/more/plugins/views/plugin_screen.dart';
import 'package:cashor_app/screens/src/more/profile/profile_screen.dart';
import 'package:cashor_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void onRoute(Widget onRoute) {
    Get.to(() => onRoute);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text("Your Settings", style: boldStyle),
        ListButton(
          imageUrl: "user.svg",
          label: "Profile",
          desc: "Edit your profile",
          onPressed: () {
            onRoute(const ProfileScreen());
          },
        ),
        // ListButton(
        //   imageUrl: "lock.svg",
        //   label: "Change Password",
        //   desc: "Change your password",
        //   onPressed: () {
        //     onRoute(const ChangePasswordScreen());
        //   },
        // ),
        ListButton(
          imageUrl: "settings.svg",
          label: "Business Settings",
          desc: "Settings specific to your business",
          onPressed: () {
            onRoute(const BusinessSettingsScreen());
          },
        ),
        ListButton(
          imageUrl: "following.svg",
          label: "Manage Customers and Suppliers",
          desc: "Settings specific to manage your suppliers and customers",
          onPressed: () {
            onRoute(const ManagePeopleScreen());
          },
        ),
        ListButton(
          imageUrl: "integration.svg",
          label: "Plugins",
          desc:
              "Add Plugins from out plugin library to enchange your business experience",
          onPressed: () {
            onRoute(const PluginScreen());
          },
        ),
        ListButton(
          imageUrl: "histogram.svg",
          label: "Analytics",
          desc: "Coming Soon in v2 ....",
          onPressed: () {
            onRoute(const WebViewScreen(
              title: "Coming Soon",
              url: "https://cashor.vercel.app/feedback",
            ));
          },
        ),
        const SizedBox(height: 50),
        const Text("General Settings", style: boldStyle),
        // ListButton(
        //   imageUrl: "settings.svg",
        //   label: "App Settings",
        //   desc: "Theme, Security, Language, Country",
        //   onPressed: () {},
        // ),
        ListButton(
          imageUrl: "chat.svg",
          label: "Feedback",
          desc: "Get your feedback of the app",
          onPressed: () {
            onRoute(const WebViewScreen(
              title: "Feedback",
              url: "https://cashor.vercel.app/feedback",
            ));
          },
        ),
        ListButton(
          imageUrl: "info.svg",
          label: "About Cashor for Business",
          desc: "About us, Privacy Policy, T&C",
          onPressed: () {
            onRoute(const WebViewScreen(
              title: "About Cashor",
              url: "https://cashor.vercel.app/about",
            ));
          },
        ),
        ListButton(
          imageUrl: "share.svg",
          label: "Share Cashor for Business",
          desc: "Share Cashor - your own business app",
          onPressed: () async {
            await Share.share(
                "Check out Cashor - all in one businesss app. https://cashor.vercel.app");
          },
        ),
        const SizedBox(height: 30),
        PrimaryButton(
          label: "Logout",
          onPress: () async {
            await AuthService().logout();
            GetStorage().remove('userId');
            GetStorage().remove('businessId');
            Get.off(() => const SplashScreen());
          },
        ),
        const SizedBox(height: 30),
        const Center(
          child: Text(
            "Version: ${Config.version}",
            style: lightStyle,
          ),
        ),
        const SizedBox(height: 30),
        const Center(
          child: Text(
            Config.appName,
            style: allRedTextStyle,
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
