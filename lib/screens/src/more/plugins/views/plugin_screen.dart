import 'package:cashor_app/components/list_button.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/components/webview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PluginScreen extends StatefulWidget {
  const PluginScreen({super.key});

  @override
  State<PluginScreen> createState() => _PluginScreenState();
}

class _PluginScreenState extends State<PluginScreen> {
  void comingSoon() {
    Get.to(() => const WebViewScreen(
          title: "Coming Soon",
          url: "https://cashor.vercel.app/feedback",
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: "Plugins",
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListButton(
              imageUrl: "mail.svg",
              label: "SMTP Mailer",
              desc: "Coming Soon in v2....",
              onPressed: () {
                comingSoon();
              },
            ),
            ListButton(
              imageUrl: "tawk.svg",
              label: "Tawk to",
              desc: "Coming Soon in v2....",
              onPressed: () {
                comingSoon();
              },
            ),
            ListButton(
              imageUrl: "chat.svg",
              label: "GPT AI in Chat",
              desc: "Coming Soon in v2....",
              onPressed: () {
                comingSoon();
              },
            ),
            ListButton(
              imageUrl: "slack.svg",
              label: "Slack Integration",
              desc: "Coming Soon in v2....",
              onPressed: () {
                comingSoon();
              },
            ),
            ListButton(
              imageUrl: "discord.svg",
              label: "Discord Integration",
              desc: "Coming Soon in v2....",
              onPressed: () {
                comingSoon();
              },
            ),
          ],
        ),
      ),
    );
  }
}
