import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xpenso/DataBase/db_connnection.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/ListBuilders/month_list.dart';
import 'package:xpenso/ListBuilders/year_list.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Utils/drawer_widget.dart';
import 'package:xpenso/Utils/switch_card.dart';
import 'Utils/expense_card.dart';
import 'constants/constant_variables.dart';

//double back delay
// var dTime;

//Main Page Controllers

PageController cardPageController = PageController();
PageController listPageController = PageController();

//Scroll contollers
ScrollController drawerScroll = ScrollController();
ScrollController mainPageDrawer = ScrollController();

//Main Page Controller Variables
int durationIndex = 0;
int listindex = 0;

//Service Reference
final service = Services();

//************************ Main Page Starts Here ************************/

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primarySwatch: colorPrimary,
        splashColor: transparent,
        splashFactory: NoSplash.splashFactory,
        focusColor: transparent,
        highlightColor: transparent),
    home: const MainHomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
    debugPrint('Cache Cleared');
  }

  @override
  void initState() {
    debugPrint('Home Page Initstate Called | HomePage Initiated');
    deleteCacheDir();
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('Home Page Dispose Called | HomePage disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

//**************************** App Bar ****************************/

      appBar: AppBar(
        centerTitle: true,
        foregroundColor: black,
        backgroundColor: appColor,
        elevation: 0,
        title: const SwitchCard(),
        // actions: [
        //   Container(
        //     padding: const EdgeInsets.only(right: deviceWidth * 0.05),
        //     child: IconButton(
        //         onPressed: () {
        //           Navigator.pushAndRemoveUntil(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const MainHomePage(),
        //               ),
        //               (route) => false);
        //         },
        //         icon: const Icon(Icons.home)),
        //   ),
        // ],
      ),

//*********************************  Body  ****************************/

      body: Container(
        color: appColor,
        child: Column(
          children: [
            SizedBox(
              height: mainTabHeight,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: cardPageController,
                children: const [
                  ExpensecardDay(),
                  ExpenseCardMonth(),
                  ExpenseCardYear()
                ],
              ),
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(height20),
                      topRight: Radius.circular(height20)),
                  color: white),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: listPageController,
                children: const [
                  DayList(),
                  MonthList(),
                  YearList(),
                ],
              ),
            ))
          ],
        ),
      ),
      //***************************** Drawer Starts Here ******************************/
      drawer: const DrawerWidget(),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainHomePage(),
              ),
              (route) => false);
        },
        icon: const Icon(
          Icons.home,
          size: height30,
        ),
        color: appColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
