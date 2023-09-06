import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sapekderas/models/letter_model.dart';
import 'package:sapekderas/models/services/hive_services.dart';
import 'package:uuid/uuid.dart';

import '../../../models/notification.dart';

part 'add_letter_state.dart';

class AddLetterCubit extends Cubit<AddLetterState> {
  final collection = FirebaseFirestore.instance
      .collection('letters')
      .withConverter<LetterModel>(
        fromFirestore: (snapshots, _) =>
            LetterModel.fromJson(snapshots.data()!),
        toFirestore: (letter, _) => letter.toJson(),
      );

  final notification = FirebaseFirestore.instance
      .collection('notifications')
      .withConverter<NotificationModel>(
        fromFirestore: (snapshots, _) =>
            NotificationModel.fromJson(snapshots.data()!),
        toFirestore: (notification, _) => notification.toJson(),
      );

  AddLetterCubit() : super(AddLetterInitial());

  void addLetter(LetterModel data) {
    try {
      emit(AddLetterLoading());
      final user = HiveServices(Hive).getUser();
      final newData = data.copyWith(userId: user.id);

      if (kDebugMode) {
        print("addletters: ${data.toJson()}");
      }
      collection.add(newData).then((value) {
        Fluttertoast.showToast(msg: "Surat berhasil dibuat");
        notification.add(NotificationModel(
          message:
              "${user.name} telah membuat surat ${data.type.name.toUpperCase()}",
          userType: "admin",
          type: data.type,
          createdAt: DateTime.now(),
          id: const Uuid().v4(),
        ));

        emit(AddLetterSuccess());
      }).catchError((e, s) {
        Fluttertoast.showToast(msg: "Surat gagal dibuat");
        if (kDebugMode) {
          print("error: ${e.toString()}, Stackrace: $s");
        }

        emit(AddLetterError(e.toString()));
      });
    } catch (e, s) {
      Fluttertoast.showToast(msg: "Surat gagal dibuat");
      if (kDebugMode) {
        print("error: ${e.toString()}, Stackrace: $s");
      }

      emit(AddLetterError(e.toString()));
    }
  }

  void updateLetter(LetterModel data) {
    try {
      emit(AddLetterLoading());
      collection.where("id", isEqualTo: data.id).get().then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.first.reference.set(data).then((value) {
            Fluttertoast.showToast(msg: "Surat berhasil diedit");

            emit(AddLetterSuccess());
          }).catchError((error) {
            Fluttertoast.showToast(msg: "Surat gagal diedit");
          });
        } else {
          Fluttertoast.showToast(msg: "Surat tidak ditemukan");
        }
      });
    } catch (e) {
      emit(AddLetterError(e.toString()));
    }
  }

  void addLetterInstant() async {
    final id = const Uuid().v4();
    final user = HiveServices(Hive).getUser();
    final letter = LetterModel(
      id: id,
      type: LetterType.skdt,
      userId: user.id,
      name: "jak",
      nik: 3312321312,
      birthPlace: "Tangerang",
      dob: DateTime(2002, 2, 2),
      gender: Gender.male,
      nationality: "Indonesia",
      religion: "Islam",
      statusMarried: "Belum Kawin",
      job: "Mahasiswa",
      address: "Jalan asdasda dadasd",
      createdAt: DateTime.now(),
      status: StatusLetter.success,
    );

    collection.add(letter);
  }
}
