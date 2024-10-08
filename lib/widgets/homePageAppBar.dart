import 'package:flutter/material.dart';
import 'package:signup_07_19/function_common/logout.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const HomeAppBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(109, 255, 255, 255),
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
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.power_settings_new_sharp,
                    fill: BorderSide.strokeAlignCenter,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    showLogoutConfirmationDialog(context);
                  },
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
