// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosary_application_1/common/widgets/loader.dart';
import 'package:cosary_application_1/features/group_details/widgets/widget_group.dart';
import 'package:cosary_application_1/features/models/group_models.dart';
import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:cosary_application_1/features/select_contacts/controller/select_chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/common/utils/utils.dart';
import 'package:cosary_application_1/common/widgets/customglassmorphism.dart';
import 'package:cosary_application_1/features/chat/controller/chat_controller.dart';
import 'package:cosary_application_1/widgets/customappbar.dart';

class CosaryGroupDetails extends ConsumerStatefulWidget {
  static const routeName = '/cosary-group-details-screen';
  String uid;
  String input;

  CosaryGroupDetails({
    Key? key,
    required this.uid,
    required this.input,
  }) : super(key: key);

  @override
  ConsumerState<CosaryGroupDetails> createState() => _CosaryGroupDetailsState();
}

class _CosaryGroupDetailsState extends ConsumerState<CosaryGroupDetails> {
  void selectProfilePic() async {
    profilePic = await pickImageFromGallery(context);
    setState(() {});
  }

  void selectContact(WidgetRef ref, String selectedContact, BuildContext context, bool isGroup) {
    ref.read(selectContactControllerProvider).selectContact(selectedContact, context, isGroup);
  }

  void selectbgPic() async {
    bgPic = await pickImageFromGallery(context);
    setState(() {});
  }

  File? profilePic;
  File? bgPic;
  bool _showedit = false;
  bool _showsubmenu = true;
  bool _showclassabout = false;
  String _selecteduser = FirebaseAuth.instance.currentUser!.uid;

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print(widget.input);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: widget.input == 'group'
            ? ref.read(chatControllerProvider).getFilterGroups(widget.uid)
            : ref.read(chatControllerProvider).getFilterosaryGroups(widget.uid),
        //future: ref.read(chatControllerProvider).getFilterosaryGroups(widget.uid),
        builder: ((context, snapshot) {
          Size size = MediaQuery.of(context).size;
          if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          } else if (snapshot.hasData) {
            final classfield = snapshot.data!;
            return FutureBuilder(
              future: ref.read(chatControllerProvider).getFilterUser(_selecteduser),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error : ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final userfield = snapshot.data!;

                  return Container(
                    decoration: BoxDecoration(
                        image: _showclassabout
                            ? DecorationImage(image: AssetImage('assets/iiumlogo.png'))
                            : DecorationImage(image: NetworkImage(userfield.bgPic), fit: BoxFit.cover)),
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: Colors.transparent,
                      body: SafeArea(
                        child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //!Left Side
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        height: size.height / 1.1115,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(),
                                            ),
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
                                                            // height: size.height / 5,
                                                            width: size.width / 5,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  _showclassabout = !_showclassabout;
                                                                });
                                                              },
                                                              child: CircleAvatar(
                                                                radius: 35,
                                                                backgroundImage: NetworkImage(classfield.groupPic),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: Container(
                                                          height: size.height / 3.125,
                                                          child: ListView.builder(
                                                            itemCount: classfield.membersUid.length,
                                                            itemBuilder: (context, index) {
                                                              return Padding(
                                                                padding: const EdgeInsets.only(bottom: 8),
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      _showclassabout = false;
                                                                      _selecteduser = classfield.membersUid[index];
                                                                    });
                                                                  },
                                                                  child: FutureBuilder(
                                                                      future: getImageData(classfield.membersUid[index].toString()),
                                                                      builder: (context, snapshot) {
                                                                        if (snapshot.hasData) {
                                                                          final image = snapshot.data!;
                                                                          return CircleAvatar(
                                                                            radius: 30,
                                                                            backgroundImage: NetworkImage(image.profilePic),
                                                                          );
                                                                        }
                                                                        return Loader();
                                                                      }),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        height: size.height / 1.1115,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: size.height / 1.1115,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  height: size.height / 2.51,
                                                ),
                                                GlassMorph(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: size.height / 2,
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(30.0),
                                                            child: !_showclassabout
                                                                ? sub_menu(
                                                                    userfield: userfield,
                                                                    onPressed: () => selectContact(ref, _selecteduser, context, false),
                                                                  )
                                                                : sub_menu_group(
                                                                    input: widget.input,
                                                                    groupfield: classfield,
                                                                  )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                    ),
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    color: orangeColor,
                  ));
                }
              }),
            ); //Users Stream
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: darkColor,
            ));
          }
        }),
      ), //Class Stream
    );
  }
}

Future<UserModel> getImageData(String username) async {
  return await FirebaseFirestore.instance.collection("users").doc(username).get().then((value) => UserModel.fromMap(value.data()!));
}
