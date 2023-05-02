import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

//************************ Colors ************************/
const Color appColor = Color(0xffB9D9EB);
const Color white = Colors.white;
const Color black = Colors.black;
const Color transparent = Colors.transparent;
const Color exRed = Color(0xffffe3e0);
//Constant Material Color
const MaterialColor colorPrimary = MaterialColor(
  0xffB9D9EB,
  <int, Color>{
    50: Color(0xFFE9F2F9),
    100: Color(0xFFC8DDEE),
    200: Color(0xFFA2C2E2),
    300: Color(0xFF7BA7D6),
    400: Color(0xFF5B92CC),
    500: Color(0xFF3B7DBF),
    600: Color(0xFF3475B8),
    700: Color(0xFF2B6BAC),
    800: Color(0xFF2361A1),
    900: Color(0xFF174F8E),
  },
);

//************************** Font Size *******************/
const double fontSizeBig = 16;
const double fontSizeSmall = 14;

//*********************** Dimensions *********************/
const double deviceWidth = 390;
const double deviceHeight = 800;
const double mainTabHeight = 125;
const double durationCardHeight = 50;
const double bottomDrawerHeight = 500;
const double categoryIconSize = 35;
const double height10 = 10;
const double height20 = 20;
const double height30 = 30;
const double height40 = 40;
const double height50 = 50;
const double height75 = 75;
const double height80 = 80;
const double height100 = 100;

//****************************** Lists ***************************/

int catIndex = 0;
List<Widget> expenseList = [
  const MyImageIcon(path: 'assets/icons/misc.png', name: 'Misc'),
  const MyImageIcon(path: 'assets/icons/bill.png', name: 'Bills'),
  const MyImageIcon(path: 'assets/icons/snacks.png', name: 'Snacks'),
  const MyImageIcon(path: 'assets/icons/veggies.png', name: 'Veggies'),
  const MyImageIcon(path: 'assets/icons/food.png', name: 'Groceries'),
  const MyImageIcon(path: 'assets/icons/dog.png', name: 'Pets'),
  const MyImageIcon(path: 'assets/icons/mobile.png', name: 'Mobile Bill'),
  const MyImageIcon(path: 'assets/icons/electricity.png', name: 'Electricity'),
  const MyImageIcon(path: 'assets/icons/fuel.png', name: 'Fuel'),
  const MyImageIcon(path: 'assets/icons/gas.png', name: 'Gas'),
  const MyImageIcon(path: 'assets/icons/internet.png', name: 'WiFi Bill'),
  const MyImageIcon(path: 'assets/icons/haircut.png', name: 'Saloon'),
  const MyImageIcon(path: 'assets/icons/savings.png', name: 'Savings'),
  const MyImageIcon(path: 'assets/icons/online-shop.png', name: 'Online'),
  const MyImageIcon(path: 'assets/icons/purchase.png', name: 'Purchase'),
  const MyImageIcon(path: 'assets/icons/service.png', name: 'Vehicle'),
  const MyImageIcon(path: 'assets/icons/stationery.png', name: 'Stationery'),
  const MyImageIcon(path: 'assets/icons/subs.png', name: 'Subscription'),
  const MyImageIcon(path: 'assets/icons/clothes.png', name: 'Clothes'),
  const MyImageIcon(path: 'assets/icons/restaurant.png', name: 'Restaurant'),
  const MyImageIcon(path: 'assets/icons/cinema.png', name: 'Movie'),
  const MyImageIcon(path: 'assets/icons/train.png', name: 'Travel'),
];

List<String> expenseNameList = [
  'Misc',
  'Bills',
  'Snacks',
  'Veggies',
  'Groceries',
  'Pets',
  'Mobile Bill',
  'Electricity',
  'Fuel',
  'Gas',
  'Wifi Bill',
  'Saloon',
  'Savings',
  'Online',
  'Purchase',
  'Vehicle',
  'Stationery',
  'Subscription',
  'Clothes',
  'Restaurant',
  'Movie',
  'Travel'
];

List<Color> expenseColorList = [
  const Color(0xFF48CAE4),
  const Color(0xFFFFADAD),
  const Color(0xFFFFD6A5),
  const Color(0xFFFDFFB6),
  const Color(0xFF15616D),
  const Color(0xFFCAFFBF),
  const Color(0xFF9BF6FF),
  const Color(0xFFC6AD94),
  const Color(0xFFA0C4FF),
  const Color(0xFF354F52),
  const Color(0xFFBDB2FF),
  const Color(0xFFFFC6FF),
  const Color(0xFFA5ABAF),
  const Color(0xFFBDE0FE),
  const Color(0xFFDDE5B6),
  const Color(0xFFFF7F51),
  const Color(0xFFA98467),
  const Color(0xFF9D8189),
  const Color(0xFFFBF8CC),
  const Color(0xFFFDE4CF),
  const Color(0xFF84A98C),
  const Color(0xFFFFEEDD),
];

List<Widget> incomeList = [
  const MyImageIcon(path: 'assets/icons/misc.png', name: 'Misc'),
  const MyImageIcon(path: 'assets/icons/salary.png', name: 'Salary'),
  const MyImageIcon(path: 'assets/icons/returns.png', name: 'Returns'),
  const MyImageIcon(path: 'assets/icons/bonus.png', name: 'Bonus'),
  const MyImageIcon(path: 'assets/icons/reimbursh.png', name: 'Reimbursh'),
];

List<String> incomeNameList = [
  'Misc',
  'Salary',
  'Returns',
  'Bonus',
  'Reimbursh'
];

//*************************** Defining Date Formats ********************/

DateTime dateSelected = DateTime.now();
DateFormat day = DateFormat('dd-MMM-yy');
DateFormat month = DateFormat('MMM - yy');
DateFormat year = DateFormat('yyyy');
DateFormat weekDay = DateFormat('EEE');
int days = DateTime(dateSelected.year, dateSelected.month + 1, 0).day;
//For Data Storage purpose
DateFormat d = DateFormat('dd');
DateFormat m = DateFormat('MMM');
DateFormat y = DateFormat('yyyy');
//For detailed view
DateFormat dateWithTime = DateFormat('dd-MM-yy    hh:mm a ');
//For Report File Name

DateFormat reportFormat = DateFormat('dd_MMM_yy_HH_mm');
