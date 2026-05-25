import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.movie_creation_outlined,
              size: 72,
              color: Color(0xFF98A2B3),
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum filme cadastrado.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Use o botão Novo para incluir o primeiro filme e salvar localmente.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}