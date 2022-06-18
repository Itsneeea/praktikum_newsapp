import 'package:dartz/dartz.dart';
import 'package:news_app/common/failure.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/article_repository.dart';

class GetBookmarkArticles {
  final ArticleRepository _repository;
  GetBookmarkArticles(this._repository);
  Future<Either<Failure, List<Article>>> execute() {
    return _repository.getBookmarkArticles();
  }
}
