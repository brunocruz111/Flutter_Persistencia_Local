class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.personalRating,
  });

  final String id;
  final String title;
  final String director;
  final double personalRating;

  factory Movie.newMovie({
    required String title,
    required String director,
    required double personalRating,
  }) {
    return Movie(
      id: DateTime.now().microsecondsSinceEpoch.toRadixString(16),
      title: title,
      director: director,
      personalRating: personalRating,
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      director: json['director'] as String,
      personalRating: (json['personalRating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'director': director,
      'personalRating': personalRating,
    };
  }

  Movie copyWith({
    String? id,
    String? title,
    String? director,
    double? personalRating,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      director: director ?? this.director,
      personalRating: personalRating ?? this.personalRating,
    );
  }
}