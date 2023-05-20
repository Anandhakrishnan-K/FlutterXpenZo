import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/DataBase/db_connnection.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/ListBuilders/month_list.dart';
import 'package:xpenso/ListBuilders/year_list.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Pages/onboarding_screen.dart';
import 'package:xpenso/Pages/splash_screen.dart';
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

//************************ Main Program Starts Here ************************/

Future main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final fisrtTime = prefs.getBool('firstTime') ?? true;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primarySwatch: colorPrimary,
        splashColor: transparent,
        splashFactory: NoSplash.splashFactory,
        focusColor: transparent,
        highlightColor: transparent),
    home: fisrtTime ? const MyOnboardingScreen() : const MySplashScreen(),
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
    return WillPopScope(
      onWillPop: () async {
        dayBloc.eventSink.add(DayEvent.jump0);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainHomePage(),
            ),
            (route) => false);
        debugPrint('Coming Back to Main Home Page by back Button');
        return false;
      },
      child: Scaffold(
        extendBody: true,

        //**************************** App Bar ****************************/

        appBar: AppBar(
          centerTitle: true,
          foregroundColor: black,
          backgroundColor: appColor,
          elevation: 0,
          title: const SwitchCard(),
          leading: IconButton(
              onPressed: () {
                dayBloc.eventSink.add(DayEvent.jump0);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainHomePage(),
                    ),
                    (route) => false);
              },
              icon: const Icon(Icons.arrow_back)),
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
        // floatingActionButton: Padding(
        //   padding:
        //       const EdgeInsets.only(bottom: height100, right: deviceWidth * 0.1),
        //   child: FloatingActionButton(
        //     elevation: 10,
        //     backgroundColor: appColor,
        //     onPressed: () {
        //       dayBloc.eventSink.add(DayEvent.jump0);
        //       Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => const MainHomePage(),
        //           ),
        //           (route) => false);
        //     },
        //     child: Image.asset(
        //       'assets/icons/back.png',
        //       scale: 20,
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
}
