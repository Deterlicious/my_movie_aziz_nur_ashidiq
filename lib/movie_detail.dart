import 'package:flutter/material.dart';
import 'movie.dart';

class MovieDetail extends StatelessWidget {
  final Movie movie;
  final String imgPath = 'https://image.tmdb.org/t/p/w500/';
  const MovieDetail(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String path = imgPath + (movie.posterPath ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                height: height / 1.5,
                child: Image.network(path, fit: BoxFit.cover),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...buildStarRating(movie.voteAverage ?? 0.0),
                        const SizedBox(width: 8.0),
                        Text(
                          movie.voteAverage != null
                              ? movie.voteAverage.toString()
                              : 'N/A',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      movie.overview ?? 'No overview available',
                      style: const TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildStarRating(double voteAverage) {
    List<Widget> stars = [];
    int fullStars = voteAverage.floor();
    int halfStars = ((voteAverage * 2) % 2).round();
    int emptyStars = 10 - fullStars - halfStars;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.orange, size: 24.0));
    }

    if (halfStars == 1) {
      stars.add(const Icon(Icons.star_half, color: Colors.orange, size: 24.0));
    }

    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.orange, size: 24.0));
    }

    return stars;
  }
}
