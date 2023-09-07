import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sapekderas/models/user_model.dart';
import 'package:sapekderas/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../../routes/routes.dart';
import '../../view_model/auth/cubit/login_cubit.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController nikController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  bool isHide = true;

  @override
  void initState() {
    super.initState();
    // emailController =
    //     TextEditingController(text: kDebugMode ? "user1@gmail.com" : "");
    // passwordController =
    //     TextEditingController(text: kDebugMode ? "12345678" : "");
    // phoneNumberController =
    //     TextEditingController(text: kDebugMode ? "08888888888" : "");
    // nameController = TextEditingController(text: kDebugMode ? "Joe" : "");

    nikController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Daftar Akun",
                style: FontsUtils.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),

              /// Bagian NIK belum bisa dimasukan ke Database
              TextFormField(
                controller: nikController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                decoration: InputDecoration(
                  labelText: 'NIK',
                  labelStyle: FontsUtils.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600
                  ),
                ),
                onFieldSubmitted: (value) {
                  setState(() {

                    if (nikController.text.length != 16) {
                      Fluttertoast.showToast(
                          msg: "NIK harus 16 angka", backgroundColor: Colors.red);

                      return;
                    }
                  });
                },
              ),


              const SizedBox(height: 12),
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  labelStyle: FontsUtils.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                // keyboardType: ,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: FontsUtils.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    labelStyle: FontsUtils.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: isHide,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: FontsUtils.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isHide = !isHide;
                      });
                    },
                    child: isHide
                        ? const Icon(
                            Icons.visibility_rounded,
                            // color: Colors.white,
                            size: 20,
                          )
                        : const Icon(
                            Icons.visibility_off_rounded,
                            size: 20,
                            // color: Colors.white,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 150,
                height: 40,
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.main, (context) => false);
                    } else if (state is AuthError) {
                      Fluttertoast.showToast(msg: state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsUtils.bgScaffold,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black)),
                        ),
                        child: const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator()),
                      );
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (nameController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Nama tidak boleh kosong",
                          );
                        } else if (emailController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Email tidak boleh kosong",
                          );
                        } else if (!(RegUtils.regEmail
                            .hasMatch(emailController.text))) {
                          Fluttertoast.showToast(
                            msg: "Masukkan email yang benar",
                          );
                          return;
                        } else if (phoneNumberController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Nomor Telepon tidak boleh kosong",
                          );
                        } else if (passwordController.text.length >= 8) {
                          Fluttertoast.showToast(
                            msg: "Password tidak boleh kosong",
                          );
                        } else if (nikController.text == "") {
                          Fluttertoast.showToast(
                            msg: "NIK tidak boleh kosong dan harus 16 angka",
                          );
                        } else {
                          context.read<AuthCubit>().registerEvent(UserModel(
                                email: emailController.text,
                                name: nameController.text,
                                phone: phoneNumberController.text,
                                password: passwordController.text,
                                nik: nikController.text,
                                id: const Uuid().v4(),
                              ));
                          // context.read<LoginCubit>().addAdmin();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                        backgroundColor: ColorsUtils.bgScaffold,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.black)),
                      ),
                      child: Text(
                        'Daftar',
                        style: FontsUtils.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
