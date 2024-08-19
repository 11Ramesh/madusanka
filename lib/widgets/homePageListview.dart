import 'package:flutter/material.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class HomePageListView extends StatelessWidget {
  HomePageListView({
    required this.title,
    required this.subtitle,
    required this.midleTitle,
    required this.leading,
    super.key,
  });

  final List<String> title;
  final List<String> subtitle;
  final List<String> midleTitle;
  final IconData leading;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: title.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(leading),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextShow(
                text: title[index],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              TextShow(text: midleTitle[index]),
              TextShow(
                text: subtitle[index],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 2,
          thickness: 2,
          color: Colors.grey,
        ); // This adds a divider line between list items
      },
    );
  }
}
