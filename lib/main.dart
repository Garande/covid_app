import 'dart:io';
import 'dart:ui';

import 'package:covid_app/background_main.dart';
import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/blocs/movements/movements_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/trip.dart';
import 'package:covid_app/models/trip_summary.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/repositories/authenticationRepository.dart';
import 'package:covid_app/repositories/movementsRepository.dart';
import 'package:covid_app/repositories/storageRepository.dart';
import 'package:covid_app/repositories/userRepository.dart';
import 'package:covid_app/services/location_service.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:covid_app/views/board/trip_screen.dart';
import 'package:covid_app/views/drawer/navigation_home_screen.dart';
import 'package:covid_app/views/welcome/get_started.dart';
import 'package:covid_app/views/welcome/sign_in.dart';
import 'package:covid_app/views/welcome/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Bloc.observer = SimpleBlocObserver();

  // BlocSupervisor.delegate = SimpleBlocDelegate();
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();
  MovementsRepository movementsRepository = MovementsRepository();

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
          BlocProvider<MovementsBloc>(
            create: (context) => MovementsBloc(
              authenticationRepository,
              userDataRepository,
              storageRepository,
              movementsRepository,
            )..add(ListenToTrips()),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );

  var initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});

  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      // debugPrint('notification paylod: ' + payload);
    }
  });

  var channel =
      const MethodChannel('tech.garande.covid_app/background_service');
  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  channel.invokeMethod('startService', callbackHandle.toRawHandle());

  LocationService().listenToUserLocation();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MovementsBloc _movementsBloc;

  AppUser appUser;

  @override
  void initState() {
    _movementsBloc = BlocProvider.of<MovementsBloc>(context);
    fetchUser();
    super.initState();
  }

  void fetchUser() async {
    appUser = await _movementsBloc.getCurrentUser();
  }

  var _androidAppRetain = MethodChannel("android_app_retain");

  Future<bool> onBackPress(BuildContext context) {
    if (Platform.isAndroid) {
      if (Navigator.of(context).canPop()) {
        return Future.value(true);
      } else {
        _androidAppRetain.invokeMethod("sendToBackground");
        return Future.value(false);
      }
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MultiProvider(
      providers: [
        StreamProvider<UserMovement>(
          create: (_) => LocationService().locationStream,
        )
      ],
      child: MaterialApp(
        title: 'Covid Contact Tracker',
        debugShowCheckedModeBanner: false,
        // themeMode: ThemeMode.dark,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: AppTheme.fontName,
          // textTheme: new TextTheme(),
          // platform: TargetPlatform.iOS,
        ),
        home: WillPopScope(
          onWillPop: () {
            return onBackPress(context);
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is UnAuthenticated) {
                // return NavigationHomeScreen();
                return GetStarted();
              } else if (state is UnAuthenticated ||
                  state is GoogleAuthenticated ||
                  state is OtpExceptionState ||
                  state is AuthExceptionState ||
                  state is OtpSentState ||
                  state is Authenticated ||
                  state is ProfileUpdateInProgress ||
                  state is PreFillData) {
                // return NavigationHomeScreen();
                return SignInScreen(); //Sigin in with phone index 1
              } else if (state is ProfileUpdated) {
                return StreamBuilder(
                    stream: _movementsBloc.getLiveEvents(appUser),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        var data = snapshot.data.snapshot.value;
                        List<TripSummary> items = [];
                        if (data != null) {
                          data.forEach((key, item) {
                            printLog(item);
                            Trip trip = Trip.fromJson(item);
                            AppUser peerUser;
                            // if (trip.driverId != appUser.userId) {
                            //   peerUser = await userDataRepository
                            //       .getUserByUserId(trip.driverId);
                            // } else {
                            //   peerUser = await userDataRepository
                            //       .getUserByUserId(trip.userId);
                            // }

                            TripSummary tripSummary =
                                new TripSummary(appUser, peerUser, trip);
                            items.add(tripSummary);
                            // printLog(tripSummary);
                          });
                        }

                        if (items.length > 0) {
                          printLog(items[0].trip.userId);
                          return TripScreen(tripSummaries: items
                              // tripSummary: tripSummary,
                              );
                        }
                        return NavigationHomeScreen();
                      }
                      return NavigationHomeScreen();
                      // if (state is TripInProgress)
                      //   return TripScreen(
                      //     tripSummary: state.tripSummary,
                      //   );
                      // else if (state is TripTransition) return SplashScreen();
                    });
              } else {
                return SplashScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
