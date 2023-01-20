// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/common/utils/utils.dart';
import 'package:cosary_application_1/common/widgets/custom_button.dart';
import 'package:cosary_application_1/common/widgets/customglassmorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  String userName;

  UserInformationScreen({Key? key, required this.userName}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phonenumbController = TextEditingController();
  final String bgTemp =
      'https://firebasestorage.googleapis.com/v0/b/cosary-a6231.appspot.com/o/bgPic.png?alt=media&token=a121f739-4b0b-42dd-8185-55a07af9edb4';
  File? profilePic;
  File? bgPic;
  bool _showedit = false;
  bool _showsubmenu = true;
  DateTime now = DateTime.now();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectProfilePic() async {
    print(widget.userName);
    profilePic = await pickImageFromGallery(context);
    setState(() {});
  }

  void selectbgPic() async {
    bgPic = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    String phonenumber = phonenumbController.text.trim();

    if (name.isNotEmpty && phonenumber.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(context, name, profilePic, bgPic, now.toIso8601String(), phonenumber, widget.userName);
    } else {
      showSnackBar(context: context, content: 'Both fields are empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: bgPic == null
                    ? DecorationImage(
                        image: AssetImage('assets/iiumlogo.png'),
                      )
                    : DecorationImage(image: FileImage(bgPic!), fit: BoxFit.cover)),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: size.height / 2,
                                child: Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: SizedBox(
                                                width: size.width / 5,
                                                child: profilePic == null
                                                    ? const CircleAvatar(
                                                        backgroundImage: NetworkImage(
                                                          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                                                        ),
                                                        radius: 35,
                                                      )
                                                    : CircleAvatar(
                                                        backgroundImage: FileImage(
                                                          profilePic!,
                                                        ),
                                                        radius: 35,
                                                      )),
                                          ),
                                        ),
                                        Visibility(
                                          visible: _showedit,
                                          child: Positioned(
                                            bottom: -10,
                                            right: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: darkColor, shape: BoxShape.circle, border: Border.all(width: 2, color: orangeColor)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: selectProfilePic,
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: orangeColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          color: darkColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: orangeColor, width: 2),
                                        ),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(1000),
                                          onTap: () {
                                            setState(() {
                                              _showedit = !_showedit;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.settings),
                                          ),
                                        ),
                                      ),

                                      // child: InkWell(
                                      //     borderRadius: BorderRadius.circular(100.0),
                                      // onTap: () {
                                      //   setState(() {
                                      //     _showedit = !_showedit;
                                      //   });
                                      //       },
                                      //     child: Icon(
                                      //       Icons.settings,
                                      //       color: blackColor,
                                      //     )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Stack(
                                children: [
                                  Visibility(
                                    visible: _showsubmenu,
                                    maintainState: true,
                                    maintainAnimation: true,
                                    maintainSize: true,
                                    child: Stack(
                                      children: [
                                        GlassMorph(
                                          child: Container(
                                            color: Colors.transparent,
                                            height: size.height / 2,
                                            width: double.infinity,
                                            child: Column(
                                              children: [
                                                Spacer(),
                                                Container(
                                                  padding: const EdgeInsets.all(20),
                                                  child: TextField(
                                                    controller: nameController,
                                                    decoration: const InputDecoration(
                                                      hintText: 'Enter your name',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(20),
                                                  child: TextField(
                                                    controller: phonenumbController,
                                                    decoration: const InputDecoration(
                                                      hintText: 'Enter your phone number',
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                    padding: const EdgeInsets.all(20),
                                                    child: CustomButton(text: 'Save', onPressed: storeUserData, color: orangeColor)),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 20,
                                          top: 20,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: (() {
                                                setState(() {
                                                  _showsubmenu = false;
                                                });
                                              }),
                                              child: Icon(
                                                Icons.keyboard_double_arrow_down,
                                                size: 30,
                                                color: orangeColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: !_showsubmenu,
                                    child: Positioned(
                                      right: 20,
                                      bottom: 15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: (() {
                                            setState(() {
                                              _showsubmenu = true;
                                            });
                                          }),
                                          child: Icon(
                                            Icons.keyboard_double_arrow_up,
                                            size: 30,
                                            color: orangeColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ),
          Visibility(
            visible: _showedit,
            child: Positioned(
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: darkColor, shape: BoxShape.circle, border: Border.all(width: 2, color: orangeColor)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: selectbgPic,
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: orangeColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
