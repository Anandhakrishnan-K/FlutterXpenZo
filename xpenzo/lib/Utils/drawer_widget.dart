import 'package:flutter/material.dart';
import 'package:xpenso/Pages/about_page.dart';
import 'package:xpenso/Pages/chart_page.dart';
import 'package:xpenso/Pages/contact_us.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Pages/report_page.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:xpenso/main.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: deviceWidth * 0.65,
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: MyText(content: 'AK'),
              ),
              accountName: MyText(
                content: 'My Account',
                size: fontSizeSmall,
              ),
              accountEmail: MyText(content: 'My Email')),
          ListTile(
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/home.png',
              ),
              size: height30,
              color: black,
            ),
            title: const MyText(content: 'Home'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainHomePage(),
                  ),
                  (route) => false);
            },
          ),
          ListTile(
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/history.png',
              ),
              size: height30,
              color: black,
            ),
            title: const MyText(content: 'History'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false);
            },
          ),
          ListTile(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChartPage(),
                  ),
                  (route) => false);
            },
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/chart.png',
              ),
              size: height30,
              color: black,
            ),
            title: const MyText(content: 'Charts'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportPage(),
                  ),
                  (route) => false);
            },
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/report.png',
              ),
              size: height30,
              color: black,
            ),
            title: const MyText(content: 'Reports'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactPage(),
                  ),
                  (route) => false);
            },
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/contact-mail.png',
              ),
              size: height30,
              color: black,
            ),
            title: const MyText(content: 'Contact Us'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                  (route) => false);
            },
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/about.png',
              ),
              size: height30,
              color: black,
            ),
            title: const MyText(content: 'About'),
          ),
          const Expanded(child: SizedBox()),
          const ListTile(
            title: Center(
                child: MyText(
              content: 'Version V0.01',
              size: fontSizeSmall * 0.8,
            )),
          )
        ],
      ),
    );
  }
}
