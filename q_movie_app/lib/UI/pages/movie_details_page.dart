import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/movies_cubit.dart';
import 'movie_list_page.dart';
import '../../data/model/movie.dart';
import '../../helpers/my_const.dart' as consts;

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
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
                            '${consts.imgBaseUrl}${widget.movie.backdropPath}')),
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.movie.title,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headline1,
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                        ),
                      ),
                      ExpandTapWidget(
                        tapPadding: const EdgeInsets.all(25),
                        onTap: () {
                          widget.movie.favourite = !widget.movie.favourite;
                          BlocProvider.of<MovieListCubit>(context)
                              .toggleFavourite(widget.movie);
                          setState(() {});
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(widget.movie.favourite
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
                      Text('${widget.movie.voteAverage} /10 IMDb',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GenreListWidget(item: widget.movie),
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
                    widget.movie.overview,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ]),
        ),
        Positioned(
          top: 56,
          left: 4,
          child: ExpandTapWidget(
            onTap: () => Navigator.maybePop(context),
            tapPadding: const EdgeInsets.all(50),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.arrow_back,
                color: consts.textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
