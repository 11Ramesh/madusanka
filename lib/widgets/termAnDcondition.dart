import 'package:flutter/material.dart';
import 'package:signup_07_19/widgets/textShow.dart';
import 'package:url_launcher/url_launcher.dart';

class TemsANDCondition extends StatelessWidget {
  TemsANDCondition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextShow(
          text: 'I Agree to the',
          color: Colors.grey,
          fontSize: 12,
        ),
        TextButton(
            onPressed: () async {
              const url = 'https://www.kmsapp.com/termsandcondition';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw 'Could not launch $url';
              }
            },
            child: TextShow(
              text: 'Terms of Services',
              color: Colors.blue,
              fontSize: 12,
            )),
        TextShow(
          text: 'and',
          color: Colors.grey,
          fontSize: 12,
        ),
        TextButton(
          onPressed: () async {
            const url = 'https://www.kmsapp.com/privacypolicy';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            } else {
              throw 'Could not launch $url';
            }
          },
          child: TextShow(
            text: 'Privacy Policy',
            color: Colors.blue,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
