import 'package:get/get.dart';
import '../feature/auth/ui/screen/login_screen.dart';
import '../feature/auth/ui/screen/otp_screen.dart';
import '../feature/auth/ui/screen/phone_screen.dart';
import '../feature/auth/ui/screen/register_screen.dart';
import '../feature/home/ui/screens/home_screen.dart';


class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const phone = '/phone';
  static const otp = '/otp';
  static const home = '/home';

  static final pages = [
    GetPage(name: login, page: () => const LoginView()),
    GetPage(name: register, page: () => const RegisterView()),
    GetPage(name: phone, page: () => const PhoneView()),
    GetPage(name: otp, page: () => const OtpView()),
    GetPage(name: home, page: () => const HomeView()),
  ];
}
