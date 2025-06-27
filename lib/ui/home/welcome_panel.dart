import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../widgets/load_image_button.dart';

class WelcomePanel extends StatelessWidget {
  const WelcomePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            launchUrl(
              Uri.parse('https://github.com/YofarDev/BubbleYofardev'),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/github_logo.png',
                width: 30,
              ),
              const SizedBox(width: 8),
              const Text(
                "Code source of the project",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        const Text(
          "Quick youtube presentation :",
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              width: 600,
              child: YoutubePlayer(
                controller: YoutubePlayerController.fromVideoId(
                  videoId: 'F8dt5BEC8as',
                  params: const YoutubePlayerParams(showFullscreenButton: true),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.greenAccent.withAlpha(50),
              borderRadius: BorderRadius.circular(8)),
          child: const Text(
              "Update 25/06/2025 : Code refactoring + Thought bubble + small UI changes",
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 12)),

        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            launchUrl(
              Uri.parse('https://old-bubble-yofardev.web.app/'),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.redAccent.withAlpha(50),
                borderRadius: BorderRadius.circular(8)),
            child: const Text(
                "Update 27/06/2025 : Breaking changes - Click here for old version",
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12)),
          ),
        ),
        const SizedBox(height: 64),
        const LoadImageButton(),
      ],
    );
  }
}
