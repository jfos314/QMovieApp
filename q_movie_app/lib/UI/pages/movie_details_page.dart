import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/movies_cubit.dart';
import 'movie_list_page.dart';
import '../../data/model/movie.dart';
import '../../helpers/my_const.dart' as consts;

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            '${consts.imgBaseUrl}${movie.backdropPath}')),
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline1,
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                      ),
                      GestureDetector(
                        onTap: () => BlocProvider.of<MovieListCubit>(context)
                            .toggleFavourite(movie),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(BlocProvider.of<
                                            MovieListCubit>(context)
                                        .isFavourite(movie)
                                    ? 'assets/images/bookmark_selected.png'
                                    : 'assets/images/bookmark_not_selected.png')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/star.png',
                        fit: BoxFit.scaleDown,
                      ),
                      const SizedBox(height: 4),
                      Text('${movie.voteAverage} /10 IMDb',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GenreListWidget(item: movie),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Description',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    movie.overview,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ]),
        ),
        Positioned(
          top: 56,
          left: 4,
          child: GestureDetector(
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.arrow_back,
                color: consts.textColor,
              ),
            ),
            onTap: () => Navigator.maybePop(context),
          ),
        ),
      ],
    );
  }
}
