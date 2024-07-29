import 'package:flutter/material.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class HomePageListView extends StatelessWidget {
  HomePageListView({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final List<String> title;
  final List<String> subtitle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: title.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: TextShow(text: title[index]),
          subtitle: TextShow(text: subtitle[index]),
        );
      },
    );
  }
}
