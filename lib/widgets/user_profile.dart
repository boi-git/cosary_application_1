// ignore_for_file: prefer_const_constructors, no_logic_in_create_state

import 'dart:io';

import 'package:cosary_application_1/common/utils/utils.dart';
import 'package:cosary_application_1/features/group_details/widgets/widget_group.dart';
import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/common/widgets/custom_button.dart';
import 'package:cosary_application_1/common/widgets/customglassmorphism.dart';
import 'package:cosary_application_1/features/chat/controller/chat_controller.dart';
import 'package:cosary_application_1/features/group_details/screens/cosary_group_details.dart';
import 'package:cosary_application_1/widgets/customappbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDetail extends ConsumerStatefulWidget {
  static const routeName = '/profile-detail-screen';

  const ProfileDetail({
    super.key,
  });

  @override
  ConsumerState<ProfileDetail> createState() => _ProfileDetailDetailState();
}

class _ProfileDetailDetailState extends ConsumerState<ProfileDetail> {
  File? profilePic;
  File? bgPic;

  void selectProfilePic() async {
    profilePic = await pickImageFromGallery(context);
    print(profilePic.toString());
    ref.read(chatControllerProvider).updateDp(context, profilePic);
    setState(() {});
  }

  void selectbgPic() async {
    bgPic = await pickImageFromGallery(context);
    ref.read(chatControllerProvider).updateBg(context, bgPic);
    setState(() {});
  }

  TextEditingController aboutController = TextEditingController();

  String userID = "";
  Size size = Size(1, 1);
  bool _showedit = false;
  bool _showsubmenu = true;
  String url = '';
  bool typeofImage = true;

  @override
  Widget build(BuildContext context) {
    setState(() {
      size = MediaQuery.of(context).size;
    });

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: ref.read(chatControllerProvider).getFilterUser(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error :${snapshot.error}');
            } else if (snapshot.hasData) {
              final users = snapshot.data!;

              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data!.bgPic.toString(),
                            ),
                            fit: BoxFit.cover)),
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
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
                                                        // height: size.height / 5,
                                                        width: size.width / 5,
                                                        child: CircleAvatar(
                                                          radius: 35,
                                                          backgroundImage: NetworkImage(users.profilePic),
                                                          backgroundColor: orangeColor,
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
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _showedit = !_showedit;
                                                    });
                                                  },
                                                  icon: Icon(Icons.settings)),
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
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: size.height / 2,
                                                        child: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                                            child: sub_menu(
                                                              onPressed: () {},
                                                              userfield: users,
                                                            )),
                                                      )
                                                    ],
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
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Future openDialogAbout(String input) {
    return showDialog(
        context: context,
        builder: ((context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(color: darkColor, borderRadius: BorderRadius.all(Radius.circular(20)), shape: BoxShape.rectangle),
              width: size.width,
              height: size.height / 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'About',
                    style: TextStyle(color: orangeColor),
                  ),
                  Spacer(),
                  TextField(
                    controller: aboutController,
                    style: TextStyle(color: whiteColor),
                    decoration: customInputDecoration(),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
                  Spacer(),
                  Container(
                      // ignore: prefer_const_literals_to_create_immutables
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          offset: Offset(6, 9),
                          spreadRadius: 4,
                          blurRadius: 25,
                          color: Color.fromRGBO(25, 25, 25, 0.5),
                        )
                      ]),
                      child: CustomButton(
                        text: 'Sumbit',
                        color: darkColor,
                        onPressed: () {},
                      )),
                ]),
              ),
            ),
          );
        }));
  }

  Future openDialogPassword(String input) {
    return showDialog(
        context: context,
        builder: ((context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(color: darkColor, borderRadius: BorderRadius.all(Radius.circular(20)), shape: BoxShape.rectangle),
              width: size.width,
              height: size.height / 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Current Password',
                    style: TextStyle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                    child: TextField(
                      style: TextStyle(color: whiteColor),
                      decoration: customInputDecoration(),
                      obscureText: true,
                    ),
                  ),
                  Text(
                    'New Password',
                    style: TextStyle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                    child: TextField(
                      style: TextStyle(color: whiteColor),
                      decoration: customInputDecoration(),
                      obscureText: true,
                    ),
                  ),
                  Text(
                    'Confirm Password',
                    style: TextStyle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: TextField(
                      style: TextStyle(color: whiteColor),
                      decoration: customInputDecoration(),
                      obscureText: true,
                    ),
                  ),
                  Spacer(),
                  Container(
                    // ignore: prefer_const_literals_to_create_immutables
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        offset: Offset(6, 9),
                        spreadRadius: 4,
                        blurRadius: 25,
                        color: Color.fromRGBO(25, 25, 25, 0.5),
                      )
                    ]),
                    child: CustomButton(text: 'Sumbit', color: darkColor, onPressed: () {}),
                  ),
                ]),
              ),
            ),
          );
        }));
  }

  InputDecoration customInputDecoration() {
    return InputDecoration(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: orangeColor)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: orangeColor), borderRadius: BorderRadius.all(Radius.circular(15))),
        border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: orangeColor), borderRadius: BorderRadius.all(Radius.circular(15))));
  }

  void sumbit() {
    Navigator.of(context).pop();
  }

  // Widget buildText1(user.User user) {
  //   return Column(
  //     children: [
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(
  //             flex: 1,
  //             child: Center(
  //                 child: Padding(
  //               padding: const EdgeInsets.only(top: 20.0),
  //               child: GestureDetector(
  //                 onTap: () {
  //                   setState(() {
  //                     _showedit = !_showedit;
  //                   });
  //                 },
  //                 child: CircleAvatar(
  //                   radius: 35,
  //                 ),
  //               ),
  //             )),
  //           ),
  //           Expanded(
  //             flex: 4,
  //             child: GlassMorph(
  //               child: Column(children: [
  //                 SizedBox(
  //                   height: size.height / 2,
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(
  //                         vertical: 20.0, horizontal: 25),
  //                     child: _showedit ? editText(user) : buildText(user),
  //                   ),
  //                 )
  //               ]),
  //             ),
  //           )
  //         ],
  //       )
  //     ],
  //   );
  // }

//   Widget editText() {
//     return Expanded(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     user.name,
//                     style: header1(orangeColor),
//                   ),
//                   Text(
//                     user.role,
//                     style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
//                   ),
//                 ],
//               ),
//               Spacer(),
//             ],
//           ),
//           Spacer(),
//           ListTile(
//             dense: true,
//             contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
//             leading: Icon(Icons.question_mark),
//             title: Text(
//               'About',
//               style: h1orange(),
//             ),
//             trailing: IconButton(
//               icon: Icon(Icons.arrow_forward_ios_rounded),
//               onPressed: () {
//                 openDialogAbout('About');
//               },
//             ),
//           ),
//           Divider(
//             thickness: 1,
//           ),
//           ListTile(
//             dense: true,
//             contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
//             leading: Icon(Icons.lock),
//             title: Text(
//               'Passowrd',
//               style: h1orange(),
//             ),
//             trailing: IconButton(
//               icon: Icon(Icons.arrow_forward_ios_rounded),
//               onPressed: () {
//                 openDialogPassword('input');
//               },
//             ),
//           ),
//           Spacer(),
//         ],
//       ),
//     );
//   }
// }
}
