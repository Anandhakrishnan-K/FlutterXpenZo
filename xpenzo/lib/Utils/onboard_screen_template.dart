import 'package:flutter/material.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

//Controllers
TextEditingController fnameControllerOnboard = TextEditingController();
TextEditingController lnameControllerOnboard = TextEditingController();

class OnboardingFirstScreen extends StatelessWidget {
  const OnboardingFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: kToolbarHeight,
        ),
        MyText(
          content: 'Welcome',
          size: MediaQuery.of(context).size.height * 0.03,
          color: appColor,
          isHeader: true,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.075,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Image.asset('assets/images/track.png'),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.075,
        ),
        MyText(
          content: 'Simple and Intuitive Design',
          size: MediaQuery.of(context).size.height * 0.02,
          isHeader: true,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * 0.07),
          child: MyText(
            size: MediaQuery.of(context).size.height * 0.018,
            content:
                'Xpenso has a clean and user-friendly interface that makes it easy for you to enter your expenses and manage your budget.',
            maxlines: 4,
          ),
        )
      ],
    );
  }
}

class OnboardingSecondScreen extends StatelessWidget {
  const OnboardingSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: kToolbarHeight,
        ),
        MyText(
          content: 'Welcome',
          size: MediaQuery.of(context).size.height * 0.03,
          color: appColor,
          isHeader: true,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.075,
        ),
        SizedBox(
          height: height100 * 2,
          child: Image.asset('assets/images/attach.png'),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.075,
        ),
        MyText(
          content: 'Smart Receipt Attachments',
          size: MediaQuery.of(context).size.height * 0.02,
          isHeader: true,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * 0.05),
          child: MyText(
            content:
                'No more searching for misplaced receipts. Xpenzo enables you to snap photos of your receipts directly from your gallery.',
            maxlines: 4,
            size: MediaQuery.of(context).size.height * 0.018,
          ),
        )
      ],
    );
  }
}

class OnboardingThirdScreen extends StatelessWidget {
  const OnboardingThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: kToolbarHeight,
        ),
        MyText(
          content: 'Welcome',
          size: MediaQuery.of(context).size.height * 0.03,
          color: appColor,
          isHeader: true,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.075,
        ),
        SizedBox(
          height: height100 * 2,
          child: Image.asset('assets/images/analytics.png'),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.075,
        ),
        MyText(
          content: 'Reports and Analytics',
          size: MediaQuery.of(context).size.height * 0.02,
          isHeader: true,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * 0.07),
          child: MyText(
            content:
                'You can view detailed reports and analytics to gain insights into your spending habits and financial trends.',
            maxlines: 4,
            size: MediaQuery.of(context).size.height * 0.018,
          ),
        )
      ],
    );
  }
}

class OnboardingFourthScreen extends StatefulWidget {
  const OnboardingFourthScreen({super.key});

  @override
  State<OnboardingFourthScreen> createState() => _OnboardingFourthScreenState();
}

class _OnboardingFourthScreenState extends State<OnboardingFourthScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),
          MyText(
            content: 'Start Saving',
            size: MediaQuery.of(context).size.height * 0.03,
            color: appColor,
            isHeader: true,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.075,
          ),
          SizedBox(
            height: height100 * 2,
            child: Image.asset('assets/images/save.png'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          MyText(
            content: 'Enter Your First and Last Name',
            size: MediaQuery.of(context).size.height * 0.02,
            isHeader: true,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          SizedBox(
            width: deviceWidth * 0.7,
            child: TextField(
              controller: fnameControllerOnboard,
              decoration: InputDecoration(
                  suffixIconColor: appColor,
                  suffixIcon: IconButton(
                      onPressed: () {
                        fnameControllerOnboard.clear();
                      },
                      icon: const Icon(Icons.cancel_outlined)),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  label: const Center(child: MyText(content: 'First Name'))),
            ),
          ),
          const SizedBox(
            height: height30,
          ),
          SizedBox(
            width: deviceWidth * 0.7,
            child: TextField(
              controller: lnameControllerOnboard,
              decoration: InputDecoration(
                  suffixIconColor: appColor,
                  suffixIcon: IconButton(
                      onPressed: () {
                        lnameControllerOnboard.clear();
                      },
                      icon: const Icon(Icons.cancel_outlined)),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  label: const Center(child: MyText(content: 'Last Name'))),
            ),
          ),
        ],
      ),
    );
  }
}
