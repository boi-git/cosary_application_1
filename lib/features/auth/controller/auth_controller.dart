import 'dart:io';

import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cosary_application_1/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final qwe = StreamProvider((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithUsername(BuildContext context, String userName, String password) {
    authRepository.loginWithUsername(context, userName, password);
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic, File? bgPic, String lastOnline, String phoneNumber, String userName) {
    authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
      bgPic: bgPic,
      lastOnline: lastOnline,
      phoneNumber: phoneNumber,
      userName: userName,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
