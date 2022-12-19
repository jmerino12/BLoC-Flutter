import 'dart:async';

import 'package:article_finder/bloc/bloc.dart';
import 'package:article_finder/data/article.dart';
import 'package:article_finder/data/rw_client.dart';
import 'package:rxdart/rxdart.dart';

class ArticleDetailBloc implements Bloc {
  final String id;
  final _refreshController = StreamController<void>();
  final _client = RWClient();

  late Stream<Article?> articleStream;

  ArticleDetailBloc({
    required this.id,
  }) {
    articleStream = _refreshController.stream
        .startWith({})
        .mapTo(id)
        .switchMap(
          (id) => _client.getDetailArticle(id).asStream(),
        )
        .asBroadcastStream();
  }

  Future refresh() {
    final future = articleStream.first;
    _refreshController.sink.add({});
    return future;
  }

  @override
  void dispose() {
    _refreshController.close();
  }
}
