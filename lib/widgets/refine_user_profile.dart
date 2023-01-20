// ignore_for_file: prefer_const_constructors, no_logic_in_create_state

import 'package:cosary_application_1/features/group_details/widgets/widget_group.dart';
import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/common/widgets/customglassmorphism.dart';
import 'package:cosary_application_1/features/chat/controller/chat_controller.dart';
import 'package:cosary_application_1/features/group_details/screens/cosary_group_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserBackDetail extends ConsumerStatefulWidget {
  static const routeName = '/user-profile-screen';
  String username;
  UserBackDetail({super.key, required this.username});

  @override
  ConsumerState<UserBackDetail> createState() => _UserBackDetailState();
}

class _UserBackDetailState extends ConsumerState<UserBackDetail> {
  TextEditingController aboutController = TextEditingController();

  bool _showsubmenu = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() {});

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: ref.read(chatControllerProvider).getFilterUser(widget.username),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error :${snapshot.error}');
            } else if (snapshot.hasData) {
              final users = snapshot.data!;

              return Container(
                decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(snapshot.data!.bgPic.toString()))),
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
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: SizedBox(
                                                width: size.width / 5,
                                                child: CircleAvatar(
                                                  radius: 35,
                                                  backgroundImage: NetworkImage(users.profilePic),
                                                  backgroundColor: orangeColor,
                                                )),
                                          ),
                                        ),
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
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: size.height / 2,
                                                child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                                    child: sub_menu(
                                                      userfield: users,
                                                      onPressed: () {},
                                                    )),
                                              ),
                                            ),
                                            Positioned(
                                              right: 20,
                                              bottom: 15,
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
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
