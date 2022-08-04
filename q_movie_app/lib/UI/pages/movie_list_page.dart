import 'package:expand_tap_area/expand_tap_area.dart';
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
  int _selectedScreenIndex = 0;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        backgroundColor: consts.backgroundColorNavBar,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/movie_selected.png"),
            ),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/bookmark_ticked_not_selected.png"),
            ),
            label: 'Favourites',
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: BlocBuilder<MovieListCubit, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return buildLoadingWidget();
            } else if (state is MovieListLoadingNextPage) {
              return buildLoadedWidget(
                  _selectedScreenIndex == 0
                      ? state.movieList.movieList
                      : state.movieList.favouriteList!,
                  _listController,
                  false,
                  context,
                  _selectedScreenIndex);
            } else if (state is MovieListLoaded) {
              return buildLoadedWidget(
                  _selectedScreenIndex == 0
                      ? state.movieList.movieList
                      : state.movieList.favouriteList!,
                  _listController,
                  false,
                  context,
                  _selectedScreenIndex);
            } else if (state is MovieListLoadedRemoteFailed) {
              return buildLoadedWidget(
                  _selectedScreenIndex == 0
                      ? state.movieList.movieList
                      : state.movieList.favouriteList!,
                  _listController,
                  true,
                  context,
                  _selectedScreenIndex);
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
    bool remoteFailed, BuildContext context, int selectedIndex) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Image.asset(
        'assets/images/q_logo_small.png',
        fit: BoxFit.scaleDown,
      ),
      const SizedBox(height: 30),
      Text(
        selectedIndex == 0 ? 'Popular' : 'Favorites',
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
              return MovieTileWidget(item: movieList[index]);
            } else {
              if (remoteFailed) {
                return const Center(
                  child: Text('web service failed'),
                );
              } else if (selectedIndex == 0) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return Container();
              }
            }
          }),
        ),
      ),
    ],
  );
}

class MovieTileWidget extends StatefulWidget {
  const MovieTileWidget({
    Key? key,
    required this.item,
  }) : super(key: key);
  final Movie item;

  @override
  State<MovieTileWidget> createState() => _MovieTileWidgetState();
}

class _MovieTileWidgetState extends State<MovieTileWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BlocProvider.of<NavigationCubit>(context)
          .showMovieDetails(widget.item),
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
                      '${consts.imgBaseUrl}${widget.item.backdropPath}'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.title,
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
                      Text('${widget.item.voteAverage} /10 IMDb',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1),
                      const SizedBox(height: 16),
                    ],
                  ),
                  if (widget.item.genreNames.isNotEmpty)
                    const SizedBox(height: 12),
                  GenreListWidget(item: widget.item),
                ],
              ),
            ),
            ExpandTapWidget(
              tapPadding: const EdgeInsets.all(25),
              onTap: () {
                widget.item.favourite = !widget.item.favourite;
                BlocProvider.of<MovieListCubit>(context)
                    .toggleFavourite(widget.item);
                setState(() {});
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(BlocProvider.of<MovieListCubit>(context)
                              .isFavourite(widget.item)
                          ? 'assets/images/bookmark_selected.png'
                          : 'assets/images/bookmark_not_selected.png')),
                ),
              ),
            ),
          ],
        ),
      ),
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
