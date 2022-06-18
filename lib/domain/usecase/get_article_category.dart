import 'package:news_app/common/failure.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/article_repository.dart';
import 'package:dartz/dartz.dart';

class GetArticleCategory {
  final ArticleRepository repository;
  GetArticleCategory(this.repository);
  Future<Either<Failure, List<Article>>> execute(String category) {
    return repository.getArticleCategory(category);
  }
}
