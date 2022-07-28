import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/movies_cubit.dart';
import '../../cubit/navigation_cubit.dart';
import '../../data/model/movie.dart';
import '../../helpers/my_const.dart' as consts;

class MovieListPage extends StatefulWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final _listController = ScrollController();
  @override
  void initState() {
    super.initState();

    _listController.addListener(() {
      if (_listController.position.maxScrollExtent == _listController.offset) {
        BlocProvider.of<MovieListCubit>(context)
            .getNextPageMovieList(apiKey: consts.apiKey);
      }
    });
  }

  @override
  void dispose() {
    _listController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: BlocBuilder<MovieListCubit, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return buildLoadingWidget();
            } else if (state is MovieListLoadingNextPage) {
              return buildLoadedWidget(
                  state.movieList.movieList, _listController, false, context);
            } else if (state is MovieListLoaded) {
              return buildLoadedWidget(
                  state.movieList.movieList, _listController, false, context);
            } else if (state is MovieListLoadedRemoteFailed) {
              return buildLoadedWidget(
                  state.movieList.movieList, _listController, true, context);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

Widget buildLoadingWidget() {
  return const Center(child: CircularProgressIndicator());
}

Widget buildLoadingNextPageWidget(
    List<Movie> movieList, ScrollController listController) {
  return const Text('loading next page...');
}

Widget buildLoadedWidget(List<Movie> movieList, ScrollController listController,
    bool remoteFailed, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Image.asset(
        'assets/images/q_logo_small.png',
        fit: BoxFit.scaleDown,
      ),
      const SizedBox(height: 30),
      Text(
        'Popular',
        style: Theme.of(context).textTheme.headline1,
      ),
      const SizedBox(height: 20),
      Expanded(
        child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: listController,
            itemCount: movieList.length + 1,
            itemBuilder: ((context, index) {
              if (index < movieList.length) {
                final item = movieList[index];
                final title = item.title;
                final rating = item.voteAverage;
                return MovieTileWidget(
                    item: item, title: title, rating: rating);
              } else {
                if (remoteFailed) {
                  return const Center(
                    child: Text('web service failed'),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              }
            })),
      ),
    ],
  );
}

class MovieTileWidget extends StatelessWidget {
  const MovieTileWidget({
    Key? key,
    required this.item,
    required this.title,
    required this.rating,
  }) : super(key: key);

  final Movie item;
  final String title;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          BlocProvider.of<NavigationCubit>(context).showMovieDetails(item),
      child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          '${consts.imgBaseUrl}${item.backdropPath}')),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline2,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/star.png',
                          fit: BoxFit.scaleDown,
                        ),
                        const SizedBox(height: 4),
                        Text('$rating /10 IMDb',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle1),
                        const SizedBox(height: 16),
                      ],
                    ),
                    if (item.genreNames.isNotEmpty) const SizedBox(height: 12),
                    GenreListWidget(item: item),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class GenreListWidget extends StatelessWidget {
  const GenreListWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Movie item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 21,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: item.genreNames.length,
        itemBuilder: ((contextGenre, indexGenre) {
          final title = item.genreNames[indexGenre];
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    width: 5.0, color: const Color.fromRGBO(236, 155, 62, 0.2)),
              ),
              child: Text(title,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle2),
            ),
          );
        }),
      ),
    );
  }
}
