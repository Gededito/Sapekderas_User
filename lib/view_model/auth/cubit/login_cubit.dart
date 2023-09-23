import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sapekderas/models/services/hive_services.dart';
import 'package:sapekderas/models/user_model.dart';
import 'package:uuid/uuid.dart';

part 'login_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final collection = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  AuthCubit() : super(AuthInitial());

  void loginEvent(UserModel user) async {
    emit(AuthLoading());
    try {
      final querySnapshot =
          await collection.where('email', isEqualTo: user.email).get();

      if (querySnapshot.docs.isNotEmpty) {
        final getUser = querySnapshot.docs.first.data();
        print(getUser.toJson());

        if (_isPasswordCorrect(user.password, getUser.password) && getUser.type == "user"
              && getUser.isVerified == true) {
            await HiveServices(Hive).storeUser(getUser);
            emit(AuthSuccess());
        } else {
          if (getUser.isVerified == false) {
            emit(const AuthError("Silahkan Verifikasi Admin"));
          } else {
            emit(const AuthError("Password tidak sama"));
          }
        }
      } else {
        emit(const AuthError("User tidak ditemukan"));
      }
    } catch (e, s) {
      debugPrint("loginEvent\nError: ${e.toString()}\nStackRace: $s");

      emit(AuthError(e.toString()));
    }
  }

  void registerEvent(UserModel user) async {
    emit(AuthLoading());
    try {
      final querySnapshot =
          await collection.where('email', isEqualTo: user.email).get();
      if (querySnapshot.docs.isNotEmpty) {
        emit(const AuthError("Email sudah terdaftar"));
      } else {
        final password = _hashPassword(user.password);
        collection.add(user.copyWith(password: password)).then((value) async {
          await HiveServices(Hive).storeUser(user);

          emit(AuthSuccess());
        }).catchError((error) {
          emit(AuthError(error.toString()));
        });
      }
    } catch (e, s) {
      debugPrint("loginEvent\nError: ${e.toString()}\nStackRace: $s");

      emit(AuthError(e.toString()));
    }
  }

  void addAdmin() async {
    final password = _hashPassword("12345678");
    final id = const Uuid().v4();
    final user = UserModel(email: "test@gmail.com", password: password, id: id);
    final querySnapshot =
        await collection.where('email', isEqualTo: user.email).get();
    if (querySnapshot.docs.isEmpty) {
      collection.add(user);
    }
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool _isPasswordCorrect(String enteredPassword, String storedHashedPassword) {
    var enteredPasswordHash = _hashPassword(enteredPassword);
    return enteredPasswordHash == storedHashedPassword;
  }
}
