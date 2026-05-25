# Flutter_Persistencia_Local

Aplicação Flutter desenvolvida para a atividade de recuperação de frequência, baseada no PDF do enunciado. O tema do aluno Bruno Luis da Cruz é um CRUD de filmes assistidos, usando a classe de modelo `Movie` e persistência local com `SharedPreferences` em formato JSON.

## Objetivo

O objetivo do projeto é registrar filmes assistidos com persistência local, permitindo ao usuário:

- cadastrar novos filmes;
- listar os filmes já salvos;
- visualizar os dados do registro na tela;
- editar um filme existente;
- remover um filme com confirmação;
- limpar todos os dados com confirmação.

A tela inicial é a listagem, como solicitado no enunciado. Todos os campos do formulário são obrigatórios, então o salvamento só acontece quando o cadastro está completo e válido.

## Tema do trabalho

O aplicativo trabalha com os seguintes dados de cada filme:

- Título;
- Diretor;
- Avaliação pessoal de 0 a 10.

Cada item é armazenado localmente como JSON dentro do `SharedPreferences`, para que os dados continuem disponíveis mesmo após fechar o aplicativo.

## Estrutura do projeto

```
lib/
	app.dart
	main.dart
	models/
		movie.dart
	pages/
		movie_list_page.dart
		movie_form_page.dart
	repositories/
		movie_repository.dart
	widgets/
		empty_state.dart
		movie_card.dart
```

### Função de cada parte

- `main.dart`: ponto de entrada do app.
- `app.dart`: configura tema, título e tela inicial.
- `models/movie.dart`: representa o modelo de negócio `Movie`, com `toJson` e `fromJson`.
- `repositories/movie_repository.dart`: centraliza a persistência local, carregamento, salvamento, remoção e limpeza.
- `pages/movie_list_page.dart`: tela inicial com a listagem dos filmes e as ações principais do CRUD.
- `pages/movie_form_page.dart`: formulário usado para cadastrar e editar filmes.
- `widgets/movie_card.dart`: componente visual de cada filme na lista.
- `widgets/empty_state.dart`: mensagem exibida quando não há registros salvos.

## Como o CRUD funciona

1. Ao abrir o app, a tela de listagem chama o repositório para carregar os filmes salvos.
2. O botão de novo filme abre o formulário de cadastro.
3. O formulário valida todos os campos antes de permitir salvar.
4. Ao salvar, o objeto `Movie` é convertido para JSON e persistido no `SharedPreferences`.
5. Quando o filme é editado, o mesmo fluxo é usado, mas com preenchimento prévio dos campos.
6. A exclusão exige confirmação do usuário para evitar perda acidental de dados.
7. A limpeza completa também pede confirmação antes de apagar tudo.

## Persistência local

O `SharedPreferences` armazena uma lista de strings JSON. O fluxo de persistência é este:

1. O objeto `Movie` vira um `Map` com `toJson()`.
2. O `Map` é convertido para uma string JSON.
3. As strings JSON são salvas em uma lista no `SharedPreferences`.
4. Ao abrir o app novamente, os dados são lidos e reconstruídos com `fromJson()`.

Esse formato atende ao enunciado porque é simples, leve e suficiente para armazenar registros pequenos localmente.

## Requisitos para rodar o projeto

- Flutter instalado e configurado no computador;
- Dependências baixadas com `flutter pub get`;
- Navegador para execução em Web, ou emulador/dispositivo para Android e iOS.

## Como rodar

### 1. Baixar as dependências

```bash
flutter pub get
```

### 2. Rodar na Web

```bash
flutter run -d chrome
```

### 3. Rodar no Android

```bash
flutter devices
flutter run -d <id-do-dispositivo-android>
```

### 4. Rodar no iOS

Em ambiente macOS com Xcode configurado:

```bash
flutter devices
flutter run -d <id-do-dispositivo-ios>
```

## Observações

- O projeto foi organizado para seguir a separação entre modelo, repositório e telas, como pede a atividade.
- A validação impede salvar registros incompletos.
- As mensagens com `SnackBar` ajudam a confirmar sucesso nas operações do CRUD.
- O armazenamento local é adequado para dados simples, mas não substitui um banco de dados completo em aplicações maiores.

## Resumo

Este projeto entrega um CRUD completo de filmes assistidos, com persistência local, validação de formulário, feedback visual e estrutura organizada para facilitar manutenção e avaliação.
