import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:news_app/common/network_info.dart';
import 'package:news_app/data/datasources/article_local_data_source.dart';
import 'package:news_app/data/datasources/article_remote_data_source.dart';
import 'package:news_app/data/models/article_table.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/entities/articles.dart';
import 'package:news_app/domain/repositories/article_repository.dart';
import 'package:news_app/common/exception.dart';
import 'package:news_app/common/failure.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;
  final ArticleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  ArticleRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlineArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTopHeadlineArticles();
        localDataSource.cacheTopHeadlineArticles(
            result.map((article) => ArticleTable.fromDTO(article)).toList());
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      } on TlsException catch (e) {
        return Left(CommonFailure('Certificated Not Valid:\n${e.message}'));
      }
    } else {
      try {
        final result = await localDataSource.getCachedTopHeadlineArticles();
        return Right(result.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getHeadlineBusinessArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getHeadlineBusinessArticles();
        localDataSource.cacheHeadlineBusinessArticles(
            result.map((article) => ArticleTable.fromDTO(article)).toList());
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      } on TlsException catch (e) {
        return Left(CommonFailure('Certificated Not Valid:\n${e.message}'));
      }
    } else {
      try {
        final result = await localDataSource.getCacheHeadlineBussinesArticles();
        return Right(result.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getArticleCategory(
      String category) async {
    try {
      final result = await remoteDataSource.getArticleCategory(category);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated Not Valid:\n${e.message}'));
    }
  }

  @override
  Future<Either<Failure, Articles>> searchArticles(String query,
      {int page: 1}) async {
    try {
      final result = await remoteDataSource.searchArticles(query, page);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(CommonFailure('Certificated Not Valid:\n${e.message}'));
    }
  }

  @override
  Future<Either<Failure, String>> saveBookmarkArticle(Article article) async {
    try {
      final result = await localDataSource
          .insertBookmarkArticle(ArticleTable.fromEntity(article));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> removeBookmarkArticle(Article article) async {
    try {
      final result = await localDataSource
          .removeBookmarkArticle(ArticleTable.fromEntity(article));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToBookmarkArticle(String url) async {
    final result = await localDataSource.getArticleByUrl(url);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Article>>> getBookmarkArticles() async {
    final result = await localDataSource.getBookmarkArticles();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}
