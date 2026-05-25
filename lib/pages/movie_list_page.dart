import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../widgets/empty_state.dart';
import '../widgets/movie_card.dart';
import 'movie_form_page.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final MovieRepository _repository = MovieRepository();
  List<Movie> _movies = <Movie>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      _loading = true;
    });

    final List<Movie> movies = await _repository.loadAll();
    if (!mounted) {
      return;
    }

    setState(() {
      _movies = movies;
      _loading = false;
    });
  }

  Future<void> _openForm({Movie? movie}) async {
    final Movie? result = await Navigator.of(context).push<Movie>(
      MaterialPageRoute<Movie>(
        builder: (_) => MovieFormPage(movie: movie),
      ),
    );

    if (result == null) {
      return;
    }

    final bool isEditing = movie != null;
    await _repository.upsert(result);
    await _loadMovies();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing
              ? 'Filme alterado com sucesso.'
              : 'Filme registrado com sucesso.',
        ),
      ),
    );
  }

  Future<void> _deleteMovie(Movie movie) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remover filme'),
          content: Text('Deseja remover "${movie.title}" da lista?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    await _repository.deleteById(movie.id);
    await _loadMovies();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filme removido com sucesso.')),
    );
  }

  Future<void> _clearAllMovies() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpar dados'),
          content: const Text(
            'Deseja apagar todos os filmes salvos? Essa ação não pode ser desfeita.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    await _repository.clearAll();
    await _loadMovies();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Todos os filmes foram removidos.')),
    );
  }

  String _formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFEAF2FF),
              Color(0xFFF3F6FA),
              Color(0xFFFFFAF3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Filmes assistidos',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'CRUD local com cadastro, edição, remoção e persistência.',
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'clear') {
                          _clearAllMovies();
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'clear',
                          child: Text('Limpar dados'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _movies.isEmpty
                        ? const EmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                            itemBuilder: (BuildContext context, int index) {
                              final Movie movie = _movies[index];
                              return MovieCard(
                                movie: movie,
                                ratingLabel: _formatRating(movie.personalRating),
                                onEdit: () => _openForm(movie: movie),
                                onDelete: () => _deleteMovie(movie),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                                const SizedBox(height: 12),
                            itemCount: _movies.length,
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }
}