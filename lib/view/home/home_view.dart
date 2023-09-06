import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sapekderas/utils/extension.dart';

import '../../models/letter_model.dart';
import '../../routes/routes.dart';
import '../../utils/utils.dart';
import '../../view_model/letter/get_letter/get_letter_cubit.dart';
import '../letter/letter_form_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            context.read<GetLetterCubit>().getLetterByIdUser();
          },
          child: Text(
            'Home',
            style:
                FontsUtils.poppins(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: BlocBuilder<GetLetterCubit, GetLetterState>(
          builder: (context, state) {
            if (state is GetLetterSuccess) {
              return HomeTable(models: state.allData, titleApp: "Riwayat");
            }
            return const HomeTable(models: [], titleApp: "Riwayat");
          },
        ),
      ),
    );
  }
}

class HomeTable extends StatelessWidget {
  final List<LetterModel> models;
  final String titleApp;
  final double? fontSize;
  final bool withTitleApp;
  const HomeTable(
      {super.key,
      required this.models,
      this.titleApp = "",
      this.fontSize,
      this.withTitleApp = true});

  @override
  Widget build(BuildContext context) {
    const title = [
      "Jenis Surat",
      "Tanggal",
      "Status",
    ];

    const example = ["1", "2", "3"];
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetLetterCubit>().getLetterByIdUser();
      },
      child: ListView(
        children: [
          if (withTitleApp)
            Text(
              titleApp,
              style: FontsUtils.poppins(
                  fontSize: fontSize ?? 16, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 10),
          Table(
            // defaultColumnWidth: FlexColumnWidth(2),
            border: TableBorder.all(borderRadius: BorderRadius.circular(4)),
            children: [
              TableRow(
                  children: title
                      .map((e) => Container(
                          height: 30,
                          color: Colors.blueAccent,
                          alignment: Alignment.center,
                          child: Text(e,
                              style: FontsUtils.poppins(
                                  fontSize: 12, fontWeight: FontWeight.bold))))
                      .toList()),
              ...List.generate(
                models.length,
                (index) => TableRow(
                    children: example
                        .map((e) => GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, Routes.letterDetail,
                                  arguments: LetterDetailViewArgs(
                                    crud: Crud.read,
                                    model: models[index],
                                  )),
                              child: Container(
                                  height: 30,
                                  alignment: Alignment.center,
                                  child: Text(
                                      e == "1"
                                          ? models[index]
                                              .type
                                              .name
                                              .toUpperCase()
                                          : e == "2"
                                              ? models[index]
                                                  .createdAt
                                                  .dateString()
                                              : models[index]
                                                  .status
                                                  .toFirstUpperCase(),
                                      style: FontsUtils.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal))),
                            ))
                        .toList()),
              ),
            ],
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
