import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'http_helper.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late HttpHelper helper;
  int moviesCount = 0;
  List movies = [];
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  Icon visibleIcon = const Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget searchBar = const Text(
    'Movies',
    style: TextStyle(color: Colors.white),
  );

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: searchBar,
          ),
          actions: <Widget>[
            IconButton(
              icon: visibleIcon,
              onPressed: () {
                setState(() {
                  if (visibleIcon.icon == Icons.search) {
                    visibleIcon = const Icon(Icons.cancel);
                    searchBar = TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (String text) {
                        search(text);
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    );
                  } else {
                    setState(() {
                      visibleIcon = const Icon(Icons.search);
                      searchBar = const Text('Movies');
                    });
                  }
                });
              },
            ),
          ]),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: movies.isEmpty
            ? buildShimmerLoading()
            : ListView.builder(
                itemCount: moviesCount,
                itemBuilder: (BuildContext context, int position) {
                  if (movies[position].posterPath != null) {
                    image =
                        NetworkImage(iconBase + movies[position].posterPath);
                  } else {
                    image = NetworkImage(defaultImage);
                  }
                  return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        onTap: () {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (_) => MovieDetail(movies[position]));
                          Navigator.push(context, route);
                        },
                        leading: CircleAvatar(
                          backgroundImage: image,
                        ),
                        title: Text(movies[position].title),
                        subtitle: Text('${'Released: ' +
                            movies[position].releaseDate} - Vote: ${movies[position].voteAverage}'),
                      ));
                }),
      ),
    );
  }

  Future search(text) async {
    movies = await helper.findMovies(text);
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  Future initialize() async {
    movies = [];
    movies = await helper.getUpcoming();
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  Future refresh() async {
    await initialize();
  }
}

Widget buildShimmerLoading() {
  return ListView.builder(
    itemCount: 10,
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          color: Colors.white,
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300]!,
            ),
            title: Container(
              color: Colors.grey[300]!,
              height: 20.0,
              width: double.infinity,
            ),
            subtitle: Container(
              color: Colors.grey[300]!,
              height: 14.0,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 4.0),
            ),
          ),
        ),
      );
    },
  );
}
