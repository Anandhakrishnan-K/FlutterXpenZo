// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/BLoC/profile_picture_bloc.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Utils/full_screen_widget.dart';
import 'package:xpenso/Utils/user_details.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

//BLOC initaialization
final profileUpdateBloc = ProfileUpdateBloc();

//Getting User Details
String fname = 'Guest';
String lname = 'User';
String profilePath = 'assets/icons/man.png';

//Controllers
TextEditingController fnameController = TextEditingController();
TextEditingController lnameController = TextEditingController();

//Image Storable
File? profilePic;

//Creating object for Save user details class

final user = UserProfile();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    profileUpdateBloc.eventSink.add(ProfileUpdate.update);
    super.initState();
  }

  Future<void> deleteImage(String img) async {
    try {
      final imgPath = img;
      if (imgPath.isNotEmpty) {
        await File(imgPath).delete();
        debugPrint('Image Deleted Sucessfully $imgPath');
      } else {
        debugPrint('Nothing to delete');
      }
    } catch (e) {
      debugPrint('Image Not Present ${e.toString()}');
    }
  }

  Future<File> saveImage(File tmpImgae) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imgPath = '${appDir.path}/ProfilePic${DateTime.now().toString()}.png';

    final storedImage = await tmpImgae.copy(imgPath);
    user.saveProfilePath(storedImage.path);
    debugPrint('Image Saved to Local ${storedImage.path}');
    return storedImage;
  }

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
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: transparent,
            toolbarHeight: 50,
            elevation: 0,
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
                icon: const Icon(
                  Icons.arrow_back,
                )),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: profileUpdateBloc.stateStream,
                    initialData: profilePic,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        File tmpProfilePic = snapshot.data!;
                        return InstaImageViewer(
                          disableSwipeToDismiss: true,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: FileImage(tmpProfilePic),
                                    fit: BoxFit.cover)),
                            height: height100 * 2.5,
                            width: deviceWidth,

                            // child: CircleAvatar(
                            //   backgroundImage:
                            //       profilePath == 'assets/icons/man.png'
                            //           ? null
                            //           : FileImage(tmpProfilePic),
                            //   radius: height100 * 1.2,
                            // ),
                            // child: profilePath == 'assets/icons/man.png'
                            //     ? null
                            //     : Image.file(
                            //         tmpProfilePic,
                            //         fit: BoxFit.cover,
                            //       ),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: height100 * 2.5,
                          child: InstaImageViewer(
                            disableSwipeToDismiss: true,
                            child: CircleAvatar(
                              radius: height100 * 1.2,
                              child: profilePath == 'assets/icons/man.png'
                                  ? Image.asset(profilePath)
                                  : null,
                            ),
                          ),
                        );
                      }
                    }),
                const SizedBox(
                  height: height10,
                ),
                Center(
                  child: MyButton(
                      fillColor: transparent,
                      content: SizedBox(child: MyText(content: 'Edit Profile')),
                      onPressed: () async {
                        debugPrint('Have to Edit Profile Picture');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: MyText(content: 'Update Profile Picture'),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(height10),
                                  child: MyButton(
                                      borderColor: Colors.grey.shade400,
                                      content: MyText(content: 'Reset'),
                                      onPressed: () async {
                                        user.saveProfilePath(
                                            'assets/icons/man.png');
                                        String tmp =
                                            await user.getProfilePath();
                                        setState(() {
                                          profilePath = tmp;
                                        });
                                        profileUpdateBloc.eventSink
                                            .add(ProfileUpdate.update);

                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(height10),
                                  child: MyButton(
                                      borderColor: Colors.grey.shade400,
                                      content: MyText(content: 'Update'),
                                      onPressed: () async {
                                        String oldImg =
                                            await user.getProfilePath();
                                        deleteImage(oldImg);
                                        pickedFile = await picker.pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 20);
                                        if (pickedFile != null) {
                                          saveImage(File(pickedFile.path));
                                        } else {
                                          debugPrint('No Image selected');
                                        }

                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        Future.delayed(
                                            Duration(milliseconds: 1000),
                                            () async {
                                          String tmp =
                                              await user.getProfilePath();
                                          setState(() {
                                            profileUpdateBloc.eventSink
                                                .add(ProfileUpdate.update);

                                            profilePath = tmp;
                                            deleteCacheDir();
                                          });
                                        });
                                      }),
                                )
                              ],
                            );
                          },
                        );
                      }),
                ),
                const SizedBox(
                  height: height30,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: height40),
                    height: height50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(content: 'First Name :'),
                        const SizedBox(
                          width: deviceWidth * 0.05,
                        ),
                        SizedBox(
                            width: deviceWidth * 0.3,
                            child: MyText(content: fname)),
                        const SizedBox(
                          width: deviceWidth * 0.05,
                        ),
                        IconButton(
                            onPressed: () {
                              debugPrint('Changing First Name');
                              setState(() {
                                fnameController.clear();
                              });
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Padding(
                                      padding: const EdgeInsets.all(height10),
                                      child: Center(
                                          child: MyText(
                                              content: 'Enter First Name')),
                                    ),
                                    content: SizedBox(
                                      width: deviceWidth * 0.4,
                                      child: TextField(
                                        controller: fnameController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            label: Center(
                                                child: MyText(
                                                    content: 'First Name'))),
                                      ),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(height10),
                                        child: MyButton(
                                            borderColor: Colors.grey.shade500,
                                            content: MyText(content: 'Close'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(height10),
                                        child: MyButton(
                                            borderColor: Colors.grey.shade500,
                                            content: MyText(content: 'Update'),
                                            onPressed: () async {
                                              user.saveFirstName(fnameController
                                                  .text
                                                  .toString());
                                              //Getting Updated Value from the Shared Preferences
                                              String tmp =
                                                  await user.getFirstName();
                                              setState(() {
                                                fname = tmp;
                                              });

                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            }),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                        const SizedBox(
                          width: deviceWidth * 0.05,
                        ),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: height40),
                    height: height50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(content: 'Last Name :'),
                        const SizedBox(
                          width: deviceWidth * 0.05,
                        ),
                        SizedBox(
                            width: deviceWidth * 0.3,
                            child: MyText(content: lname)),
                        const SizedBox(
                          width: deviceWidth * 0.05,
                        ),
                        IconButton(
                            onPressed: () {
                              debugPrint('Changing Last Name');
                              setState(() {
                                lnameController.clear();
                              });
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Padding(
                                      padding: const EdgeInsets.all(height10),
                                      child: Center(
                                          child: MyText(
                                              content: 'Enter Last Name')),
                                    ),
                                    content: SizedBox(
                                      width: deviceWidth * 0.4,
                                      child: TextField(
                                        controller: lnameController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            label: Center(
                                                child: MyText(
                                                    content: 'Last Name'))),
                                      ),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(height10),
                                        child: MyButton(
                                            borderColor: Colors.grey.shade500,
                                            content: MyText(content: 'Close'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(height10),
                                        child: MyButton(
                                            borderColor: Colors.grey.shade500,
                                            content: MyText(content: 'Update'),
                                            onPressed: () async {
                                              debugPrint(lnameController.text
                                                  .toString());
                                              user.saveLastName(lnameController
                                                  .text
                                                  .toString());
                                              //Getting Updated Value from the Shared Preferences
                                              String tmp =
                                                  await user.getLastName();
                                              setState(() {
                                                lname = tmp;
                                                debugPrint(lname);
                                              });

                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            }),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                        const SizedBox(
                          width: deviceWidth * 0.05,
                        ),
                      ],
                    )),
                const SizedBox(height: height50),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: height20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       MyButton(
                //           fillColor: transparent,
                //           content: MyText(content: 'About'),
                //           onPressed: () {}),
                //       MyText(content: '.'),
                //       MyButton(
                //           fillColor: transparent,
                //           content: MyText(content: 'Contact Us'),
                //           onPressed: () {}),
                //       MyText(content: '.'),
                //       MyButton(
                //           fillColor: transparent,
                //           content: MyText(content: 'Help'),
                //           onPressed: () {}),
                //       // MyText(content: '.'),
                //       // MyText(content: 'Version V0.1')
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: height50,
                  child: MyText(
                    content: 'Version V1.01',
                    color: Colors.grey,
                    size: fontSizeSmall * 0.9,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
