import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieFormPage extends StatefulWidget {
  const MovieFormPage({super.key, this.movie});

  final Movie? movie;

  @override
  State<MovieFormPage> createState() => _MovieFormPageState();
}

class _MovieFormPageState extends State<MovieFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _directorController;
  late final TextEditingController _ratingController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie?.title ?? '');
    _directorController =
        TextEditingController(text: widget.movie?.director ?? '');
    _ratingController = TextEditingController(
      text: widget.movie?.personalRating.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double rating = double.parse(
      _ratingController.text.trim().replaceAll(',', '.'),
    );
    final Movie movie = (widget.movie ??
            Movie.newMovie(
              title: '',
              director: '',
              personalRating: 0,
            ))
        .copyWith(
      title: _titleController.text.trim(),
      director: _directorController.text.trim(),
      personalRating: rating,
    );

    Navigator.of(context).pop(movie);
  }

  String? _validateRating(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe a avaliação pessoal';
    }

    final double? rating = double.tryParse(value.trim().replaceAll(',', '.'));
    if (rating == null) {
      return 'Informe um número válido';
    }
    if (rating < 0 || rating > 10) {
      return 'Use um valor entre 0 e 10';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.movie != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar filme' : 'Novo filme'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _directorController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Diretor',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o diretor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ratingController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Avaliação pessoal (0 a 10)',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRating,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(isEditing ? 'Salvar alterações' : 'Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}