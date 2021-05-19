import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_moh/models/user_model.dart';
import 'package:social_media_app_moh/modules/register/cubit/states.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) {
    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user.email);
      print(value.user.uid);
      userCreate(
        uid: value.user.uid,
        name: name,
        phone: phone,
        email: email,
      );
      emit(SocialRegisterSuccessState());
    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    @required String name,
    @required String email,
    @required String phone,
    @required String uid,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uid: uid,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SocialRegisterChangePasswordVisibilityState());
  }
}
