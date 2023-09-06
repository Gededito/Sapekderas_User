import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../models/letter_model.dart';
import '../../../models/services/hive_services.dart';

part 'get_letter_state.dart';

class GetLetterCubit extends Cubit<GetLetterState> {
  final collection = FirebaseFirestore.instance
      .collection('letters')
      .withConverter<LetterModel>(
        fromFirestore: (snapshots, _) =>
            LetterModel.fromJson(snapshots.data()!),
        toFirestore: (letter, _) => letter.toJson(),
      );
  GetLetterCubit() : super(GetLetterInitial());

  void getLetterByIdUser() async {
    try {
      emit(GetLetterLoading());
      List<LetterModel> allData = [];

      final user = HiveServices(Hive).getUser();

      final querySnapshot =
          await collection.where('user_id', isEqualTo: user.id).get();

      for (var element in querySnapshot.docs) {
        allData.add(element.data());
      }
      if (kDebugMode) {
        print("allData0: ${allData.toString()}");
      }

      allData.sort((a, b) => a.createdAt!.millisecondsSinceEpoch
          .compareTo(b.createdAt!.millisecondsSinceEpoch));

      if (kDebugMode) {
        print("allData: ${allData.toString()}");
      }
      emit(GetLetterSuccess(
        allData: allData,
        errorData: const [],
        progressData: const [],
        successData: const [],
      ));
    } catch (e, s) {
      if (kDebugMode) {
        print("error: ${e.toString()}, Stackrace: $s");
      }
      emit(GetLetterError(e.toString()));
    }
  }

  void getAllData() async {
    emit(GetLetterLoading());
    List<LetterModel> allData = [];
    List<LetterModel> successData = [];
    List<LetterModel> errorData = [];
    List<LetterModel> progressData = [];

    try {
      final querySnapshot = await collection.get();

      for (var element in querySnapshot.docs) {
        allData.add(element.data());
        switch (element.data().status) {
          case StatusLetter.success:
            successData.add(element.data());
            break;
          case StatusLetter.progress:
            progressData.add(element.data());
            break;
          case StatusLetter.error:
            errorData.add(element.data());
            break;
          default:
        }
      }
      emit(GetLetterSuccess(
        allData: allData,
        successData: successData,
        errorData: errorData,
        progressData: progressData,
      ));
    } catch (e, s) {
      if (kDebugMode) {
        print("error: ${e.toString()}, Stackrace: $s");
      }
      emit(GetLetterError(e.toString()));
    }
  }

  void deleteData(LetterModel data) {
    var state = this.state;
    if (state is GetLetterSuccess) {
      List<LetterModel> allData = state.allData;
      List<LetterModel> successData = [];
      List<LetterModel> errorData = [];
      List<LetterModel> progressData = [];
      emit(GetLetterSuccess(
        allData: allData,
        successData: state.successData,
        errorData: state.errorData,
        progressData: state.progressData,
        isLoading: true,
      ));

      collection.where("id", isEqualTo: data.id).get().then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.first.reference.delete().then((value) {
            Fluttertoast.showToast(msg: "Surat berhasil dihapus");
            final allData = state.allData
              ..removeWhere((element) => element.id == data.id);

            for (var element in allData) {
              switch (element.status) {
                case StatusLetter.success:
                  successData.add(element);
                  break;
                case StatusLetter.progress:
                  progressData.add(element);
                  break;
                case StatusLetter.error:
                  errorData.add(element);
                  break;
                default:
              }
            }

            emit(GetLetterSuccess(
              allData: allData,
              successData: successData,
              errorData: errorData,
              progressData: progressData,
            ));
          }).catchError((error) {
            Fluttertoast.showToast(msg: "Surat gagal dihapus");
          });
        } else {
          Fluttertoast.showToast(msg: "Surat tidak ditemukan");
        }
      });
    }
  }
}
