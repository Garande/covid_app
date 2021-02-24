import 'dart:io';

import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/repositories/authenticationRepository.dart';
import 'package:covid_app/repositories/storageRepository.dart';
import 'package:covid_app/repositories/userRepository.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/drawer/navigation_home_screen.dart';
import 'package:covid_app/views/welcome/get_started.dart';
import 'package:covid_app/views/welcome/sign_in.dart';
import 'package:covid_app/views/welcome/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = SimpleBlocObserver();

  // BlocSupervisor.delegate = SimpleBlocDelegate();
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
                authenticationRepository: authenticationRepository,
                userDataRepository: userDataRepository,
                storageRepository: storageRepository)
              ..add(AppLaunched()),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.dark,
    //   statusBarBrightness:
    //       Platform.isAndroid ? Brightness.dark : Brightness.light,
    //   systemNavigationBarColor: Colors.white,
    //   systemNavigationBarDividerColor: Colors.grey,
    //   systemNavigationBarIconBrightness: Brightness.dark,
    // ));
    return MaterialApp(
      title: 'COVID',
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: AppTheme.fontName,
        // textTheme: new TextTheme(),
        // platform: TargetPlatform.iOS,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is UnAuthenticated) {
            return GetStarted();
          } else if (state is UnAuthenticated ||
              state is GoogleAuthenticated ||
              state is OtpExceptionState ||
              state is AuthExceptionState ||
              state is OtpSentState ||
              state is Authenticated ||
              state is ProfileUpdateInProgress ||
              state is PreFillData) {
            return SignInScreen(); //Sigin in with phone index 1
          } else if (state is ProfileUpdated) {
            return NavigationHomeScreen();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
