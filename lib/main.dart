import 'package:facebook/cubits/bloc_observer.dart';
import 'package:facebook/cubits/home/facebook_cubit.dart';
import 'package:facebook/cubits/login/cubit.dart';
import 'package:facebook/layouts/home_layout.dart';
import 'package:facebook/modules/login/login.dart';
import 'package:facebook/network/local/cache_helper.dart';
import 'package:facebook/shared/constants.dart';
import 'package:facebook/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init firebase
  await Firebase.initializeApp();

  //init cache helper
  await CacheHelper.init();

  //check which widget to open the app on.
  Widget widget;
  userId = CacheHelper.getData(key: 'userId');
  print('User ID: $userId');
  if (userId != null) {
    widget = const HomeLayout();
  } else {
    widget = LoginScreen();
  }

  //to observe bloc
  Bloc.observer = MyBlocObserver(); //get instance of bloc observer
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //Get users data and all posts
        BlocProvider(
            create: (context) => FacebookCubit()
              ..getUserData()..getPosts(),),
        BlocProvider(create: (context) => FaceLoginCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: startWidget,
        theme: lightTheme,
        themeMode: ThemeMode.light,
      ),
    );
  }
}
