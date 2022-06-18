import 'package:dartz/dartz.dart';
import 'package:news_app/common/failure.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/article_repository.dart';

class RemoveBookmarkArticle {
  final ArticleRepository repository;
  RemoveBookmarkArticle(this.repository);
  Future<Either<Failure, String>> execute(Article article) {
    return repository.removeBookmarkArticle(article);
  }
}
