import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_moh/layout/social_layout.dart';
import 'package:social_media_app_moh/modules/login_screen/login_screen.dart';
import 'package:social_media_app_moh/shared/bloc_observer.dart';
import 'package:social_media_app_moh/shared/components/constants.dart';
import 'package:social_media_app_moh/shared/cubit/cubit.dart';
import 'package:social_media_app_moh/shared/cubit/states.dart';
import 'package:social_media_app_moh/shared/network/local/cache_helper.dart';
import 'package:social_media_app_moh/shared/styles/themes.dart';

import 'layout/cubit/cubit.dart';
import 'modules/on_boarding/on_boarding_screen.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  uId = CacheHelper.getData(key: 'uid');

  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialCubit()..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            //themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            themeMode: ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
