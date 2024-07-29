import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const HomeAppBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.amber,
      automaticallyImplyLeading: false,
      // leading:  Image.asset(
      //     'assets/images/appbarTitle.png',
      //     color: Colors.white,
      //   ),

      // leadingWidth: ScreenUtil.screenWidth * 0.4,
      actions: <Widget>[
        Row(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
