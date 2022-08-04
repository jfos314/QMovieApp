import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'UI/app_navigator.dart';
import 'UI/q_theme_data.dart';
import 'cubit/movies_cubit.dart';
import 'cubit/navigation_cubit.dart';
import 'data/model/movie.dart';
import 'data/model/movie_list.dart';
import 'data/movie_repository.dart';
import 'helpers/my_const.dart' as consts;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);
  Hive.registerAdapter(MovieListAdapter());
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<MovieList>('movielist');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Q Movie App',
        theme: QThemeData().themeDataDark,
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => NavigationCubit()),
            BlocProvider(
              create: (context) => MovieListCubit(MovieRepository())
                ..getInitialMovieList(apiKey: consts.apiKey),
            ),
          ],
          child: const AppNavigator(),
        ));
  }
}
