// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosary_application_1/common/repositories/common_firebase_storage_repositories.dart';
import 'package:cosary_application_1/common/utils/utils.dart';
import 'package:cosary_application_1/common/widgets/error.dart';
import 'package:cosary_application_1/features/auth/screens/user_infomation_screens.dart';
import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:cosary_application_1/screens/mobile_layout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;

    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void navigateToUserInformation(BuildContext context, dynamic userName) {
    Navigator.pushNamed(context, UserInformationScreen.routeName, arguments: userName);
  }

  Future<User?> loginUsingEmailPassword1({required BuildContext context, required String userName, required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection("users").where("userName", isEqualTo: userName).get();
      UserCredential? userCredential;
      try {
        userCredential = await auth.signInWithEmailAndPassword(email: snap.docs[0]['email'], password: password);
      } catch (e) {}

      //1000124@gmail.com
      if (userCredential == null) {
        showSnackBar(context: context, content: 'not exist');
      } else {
        user = userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
          duration: const Duration(milliseconds: 300),
        ),
      );
    }
    return user;
  }

  Future<void> loginWithUsername(
    BuildContext context,
    String userName,
    String password,
  ) async {
    User? user = await loginUsingEmailPassword1(context: context, userName: userName, password: password);

    if (user != null) {
      print(user.uid);
      var userDataMap = await firestore.collection('users').doc(user.uid).get();
      late try1 um = try1.fromMap(userDataMap.data()!);
      print(um.lastOnline);

      if (um.lastOnline == '') {
        Navigator.pushNamed(context, UserInformationScreen.routeName, arguments: userName);
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false,
        );
      }
    }
  }

  //

  void saveUserDataToFirebase({
    required String userName,
    required String lastOnline,
    required String name,
    required File? profilePic,
    required File? bgPic,
    required ProviderRef ref,
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      String bgphotoUrl =
          'https://firebasestorage.googleapis.com/v0/b/cosary-a6231.appspot.com/o/bgPic.png?alt=media&token=a121f739-4b0b-42dd-8185-55a07af9edb4';

      if (profilePic != null) {
        photoUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }
      if (bgPic != null) {
        bgphotoUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase(
              'bgPic/$uid',
              bgPic,
            );
      }
      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        bgPic: photoUrl,
        isOnline: true,
        groupID: [],
        lastOnline: lastOnline,
        phoneNumber: phoneNumber,
        email: auth.currentUser!.email.toString(),
        userName: userName,
        type: 'students',
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map((event) => UserModel.fromMap(
          event.data()!,
        ));
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({'isOnline': isOnline});
  }
}
