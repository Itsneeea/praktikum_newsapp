import 'package:news_app/domain/repositories/article_repository.dart';

class GetBookmarkStatus {
  final ArticleRepository repository;
  GetBookmarkStatus(this.repository);
  Future<bool> execute(String url) async {
    return repository.isAddedToBookmarkArticle(url);
  }
}
