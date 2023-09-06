import 'package:flutter/material.dart';
import 'package:sapekderas/models/letter_model.dart';

import '../../routes/routes.dart';
import '../../utils/utils.dart';
import 'letter_form_view.dart';

class LetterView extends StatelessWidget {
  const LetterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Layanan Surat',
          style: FontsUtils.poppins(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: LetterType.values.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 100,
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 20),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.letterDetail,
                  arguments: LetterDetailViewArgs(
                    crud: Crud.create,
                    type: LetterType.values[index],
                    // model: LetterModel(type: LetterType.values[index], id: ""),
                  ));
              // context.read<LetterDonwloadCubit>().donwloadSkck();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                letterName[LetterType.values[index]] ?? "",
                textAlign: TextAlign.center,
                style: FontsUtils.poppins(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}

const letterName = {
  LetterType.sku: "SKU (Surat Keterangan Umum)",
  LetterType.skck: "SKCK (Surat Keterangan Catatan Kepolisian)",
  LetterType.sktm: "SKTM (Surat Keterangan Tidak Mampu)",
  LetterType.skdt: "SKDT (Surat keterangan Domisili Tinggal)",
  LetterType.skbm: "SKBM (Surat Keterangan Belum Menikah)",
  LetterType.sktps: "SKTPS (Surat KTP Sementara)",
  LetterType.spn: "SPN (Surat Pengantar Nikah)",
  LetterType.skrr: "SKRR (Surat Keterangan Rame - Rame)",
  LetterType.skk: "SKK (Surat Keterangan Kematian)",
  LetterType.skkl: "SKKL (Surat Keterangan Kenal Lahir)",
};
