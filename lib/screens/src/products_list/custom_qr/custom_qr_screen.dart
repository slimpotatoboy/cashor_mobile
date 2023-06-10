import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/config/config.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomLinkScreen extends StatefulWidget {
  const CustomLinkScreen({super.key, required this.id, required this.name});
  final String id;
  final String name;

  @override
  State<CustomLinkScreen> createState() => _CustomLinkScreenState();
}

class _CustomLinkScreenState extends State<CustomLinkScreen> {
  String link = "";

  @override
  void initState() {
    super.initState();
    link = "${Config.websiteUrl}product/${widget.id}";
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: "Generate Product QR and Link",
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QrImageView(
              data: widget.id,
              version: QrVersions.auto,
              size: 250.0,
              embeddedImage: const AssetImage('assets/images/logo11.png'),
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(20, 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                link,
                style: lightStyle,
                textAlign: TextAlign.center,
              ),
            ),
            InkWell(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: link));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Link Copied"),
                ));
              },
              child: SvgPicture.asset("assets/icons/copy.svg"),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
