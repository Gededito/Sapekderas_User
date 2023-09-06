import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view/letter/letter_form_view.dart';
import '../view/login/login_view.dart';
import '../view/main/main_view.dart';
import '../view/register/register_view.dart';
import '../view_model/auth/cubit/login_cubit.dart';
import '../view/notification/notification_view.dart';
import '../view_model/notification/cubit/notification_cubit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const login = "login";
  static const register = "register";
  static const main = "main";
  static const addUser = "add-user";
  static const letterTable = "letter-table";
  static const letterDetail = "letter-detail";
  static const notification = "notification";
}

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final settingsUri = Uri.parse(settings.name ?? "/login");
    switch (settingsUri.path) {
      case Routes.login:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.login, arguments: args),
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const LoginView(),
          ),
        );
      case Routes.register:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.register, arguments: args),
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const RegisterView(),
          ),
        );

      case Routes.main:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.main, arguments: args),
          builder: (_) {
            final args = settings.arguments as int?;
            return MainView(
              initialPage: args ?? 0,
            );
          },
        );
      // case Routes.addUser:
      //   return MaterialPageRoute(
      //       settings: RouteSettings(name: Routes.addUser, arguments: args),
      //       builder: (_) {
      //         final args = settings.arguments as AddUserViewArgs?;

      //         return BlocProvider(
      //           create: (context) => AddCitizenCubit(),
      //           child: AddUserView(args: args ?? const AddUserViewArgs()),
      //         );
      //       });
      // case Routes.letterTable:
      //   return MaterialPageRoute(
      //       settings: RouteSettings(name: Routes.letterTable, arguments: args),
      //       builder: (_) {
      //         final args = settings.arguments as LetterTableViewArgs?;

      //         return LetterTableView(args: args ?? const LetterTableViewArgs());
      //       });

      case Routes.letterDetail:
        return MaterialPageRoute(
            settings: RouteSettings(name: Routes.letterDetail, arguments: args),
            builder: (_) {
              final args = settings.arguments as LetterDetailViewArgs?;

              return LetterFormView(args: args ?? const LetterDetailViewArgs());
            });

      case Routes.notification:
        return MaterialPageRoute(
            settings: RouteSettings(name: Routes.letterDetail, arguments: args),
            builder: (_) {
              // final args = settings.arguments as LetterDetailViewArgs?;

              return BlocProvider(
                create: (context) =>
                    NotificationCubit()..getNotificationByUserId(),
                child: const NotificationView(),
              );
            });

      default:
        return null;
    }
  }
}
