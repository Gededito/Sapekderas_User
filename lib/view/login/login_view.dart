
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sapekderas/models/user_model.dart';
import 'package:sapekderas/utils/utils.dart';

import '../../routes/routes.dart';
import '../../view_model/auth/cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController emailController;

  late TextEditingController passwordController;
  bool isHide = true;

  @override
  void initState() {
    super.initState();
    //
    // emailController =
    // TextEditingController(text: kDebugMode ? "anisah@gmail.com" : "");
    // emailController =
    //     TextEditingController(text: kDebugMode ? "user1@gmail.com" : "");
    // passwordController =
    //     TextEditingController(text: kDebugMode ? "12345678" : "");

    emailController =
        TextEditingController();
    passwordController =
        TextEditingController();
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
                "SAPEKDERAS",
                style: FontsUtils.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: FontsUtils.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),
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

                          // backgroundColor:
                          //     const Color.fromRGBO(255, 255, 255, 1),
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
                        if (emailController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Email tidak boleh kosong",
                          );
                        } else if (!(RegUtils.regEmail
                            .hasMatch(emailController.text))) {
                          Fluttertoast.showToast(
                            msg: "Masukkan email yang benar",
                          );
                          return;
                        } else if (passwordController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Password tidak boleh kosong",
                          );
                        } else {
                          context.read<AuthCubit>().loginEvent(UserModel(
                                email: emailController.text,
                                password: passwordController.text,
                                id: '',
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
                        'Login',
                        style: FontsUtils.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun?',
                    style: FontsUtils.poppins(
                        fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.register);
                    },
                    child: Text(
                      'Daftar',
                      style: FontsUtils.poppins(
                          color: ColorsUtils.contentColorRed,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
