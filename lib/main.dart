import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrade/controllers/add_card_controller.dart';
import 'package:upgrade/controllers/card_view_controller.dart';
import 'package:upgrade/controllers/create_deck_controller.dart';
import 'package:upgrade/controllers/document_controller.dart';
import 'package:upgrade/controllers/main_controller.dart';
import 'package:upgrade/controllers/preparatory_year_controller.dart';
import 'package:upgrade/controllers/card_controller.dart';
import 'package:upgrade/controllers/shape_creator_controller.dart';
import 'package:upgrade/controllers/years_controller.dart';
import 'package:upgrade/di.dart';
import 'package:upgrade/resources.dart';
import 'package:upgrade/screens/Auth/activate_code.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/screens/Auth/forgot_password.dart';
import 'package:upgrade/screens/Auth/login.dart';
import 'package:upgrade/screens/Auth/register.dart';
import 'package:upgrade/screens/Preparatory%20Year/preparatory_year_screen.dart';
import 'package:upgrade/screens/card_view_screen.dart';
import 'package:upgrade/screens/creat_deck/add_card_screen.dart';
import 'package:upgrade/screens/creat_deck/shape_creator.dart';
import 'package:upgrade/screens/creat_deck/card_screen.dart';
import 'package:upgrade/screens/intro/onbording_screen.dart';
import 'package:upgrade/screens/main_screen.dart';

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  sharedPref = await SharedPreferences.getInstance();
  await initAppModule();
  await ApiController.initDio();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "SOALIX",
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.pages,
      theme: ThemeData(
        fontFamily: "ELMESSIRI",
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    );
  }
}

class AnimatedLogos extends StatefulWidget {
  const AnimatedLogos({super.key});

  @override
  AnimatedLogosState createState() => AnimatedLogosState();
}

class AnimatedLogosState extends State<AnimatedLogos>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward().then((_) {
      _controller.reverse();
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (sharedPref.getString("token") != null) {
        Get.offNamed(AppRoutes.mainRoute);
      } else {
        if (sharedPref.get("onBoarding") != null) {
          Get.offNamed(AppRoutes.loginRoute);
        } else {
          Get.offNamed(AppRoutes.onboardingRoute);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                "lib/assests/images/logo1.png",
                height: 200,
                width: 100,
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                "lib/assests/images/logo2.png",
                height: 200,
                width: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppRoutes {
  static const String searchUsersRoute = "/searchUsersRoute";
  static const String viewProfileRoute = "/viewProfileRoute";
  static const String splashRoute = "/";
  static const String onboardingRoute = "/onbordingRoute";
  static const String cardRoute = "/cardRoute";
  static const String activateCodeRoute = "/activateCodeRoute";
  static const String loginRoute = "/loginRoute";
  static const String registerRoute = "/registerRoute";
  static const String forgetPassowrdRoute = "/forgetPassowrdRoute";
  static const String addCardRoute = "/addCardRoute";
  static const String shapeCreatorRoute = "/shapeCreatorRoute";
  static const String preparatoryYearRoute = "/preparatoryYearRoute";
  static const String cardViewRoute = "/cardViewRoute";
  static const String mainRoute = "/mainRoute";

  static final List<GetPage> pages = [
    GetPage(
      name: splashRoute,
      page: () => const AnimatedLogos(),
    ),
    GetPage(
      name: onboardingRoute,
      page: () => const OnBording(),
    ),
    GetPage(
      name: cardRoute,
      page: () => const CardScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => CardController(),
        ),
      ),
    ),
    GetPage(
      name: activateCodeRoute,
      page: () => const ActivateCode(),
    ),
    GetPage(
      name: loginRoute,
      page: () => const Login(),
    ),
    GetPage(
      name: registerRoute,
      page: () => const Register(),
    ),
    GetPage(
      name: forgetPassowrdRoute,
      page: () => const ForgotPassword(),
    ),
    GetPage(
      name: addCardRoute,
      page: () => const AddCardScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => AddCardController(),
        ),
      ),
    ),
    GetPage(
      name: shapeCreatorRoute,
      page: () => const ShapeCreator(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => ShapeCreatorController(),
        ),
      ),
    ),
    GetPage(
      name: preparatoryYearRoute,
      page: () => const PreparatoryYear(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => PreparatoryYearController(),
          tag: Get.arguments['id'].toString(),
          fenix: true,
        ),
      ),
    ),
    GetPage(
      name: cardViewRoute,
      page: () => const CardViewScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => CardViewController(),
        ),
      ),
    ),
    GetPage(
      name: mainRoute,
      page: () => const MainScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => MainController(),
        ),
      ),
      bindings: [
        BindingsBuilder(
          () => Get.lazyPut(
            () => YearsController(),
          ),
        ),
        BindingsBuilder(
          () => Get.lazyPut(
            () => CreateDeckController(),
          ),
        ),
        BindingsBuilder(
          () => Get.lazyPut(
            () => DocumentController(),
          ),
        ),
      ],
    ),
  ];
}
