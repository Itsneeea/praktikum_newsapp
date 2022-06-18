import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/common/theme.dart';
import 'package:news_app/common/utils.dart';
import 'package:news_app/presentation/pages/article_category_page.dart';
import 'package:news_app/presentation/pages/detail_page.dart';
import 'package:news_app/presentation/pages/splash_page.dart';
import 'package:provider/provider.dart';
//import 'common/http_ssl_pinning.dart';
import 'domain/entities/article.dart';
import 'injection.dart' as di;
import 'presentation/bloc/article_category_bloc/article_category_bloc.dart';
import 'presentation/bloc/article_detail_bloc/article_detail_bloc.dart';
import 'presentation/bloc/article_list_bloc/article_list_bloc.dart';
import 'presentation/bloc/bookmark_article_bloc/bookmark_article_bloc.dart';
import 'presentation/bloc/search_article_bloc/search_article_bloc.dart';
import 'presentation/pages/article_webview_page.dart';
import 'presentation/pages/main_page.dart';

void main() async {
  HttpOverrides.global = MyHttpoverrides();
  WidgetsFlutterBinding.ensureInitialized();
  // await HttpSSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<ArticleTopHeadlineListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<ArticleHeadlineBusinessListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<ArticleCategoryBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchArticleBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<BookmarkArticleBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<ArticleDetailBloc>(),
        ),
      ],
      child: MaterialApp(
          title: 'Headline News',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
              primaryColor: kWhiteColor,
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              colorScheme: kColorScheme.copyWith(secondary: kPrimaryColor),
              bottomNavigationBarTheme: bottomNavigationBarTheme),
          home: SplashPage(),
          navigatorObservers: [routeObserver],
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) => SplashPage());
              case '/main-page':
                return CupertinoPageRoute(builder: (_) => MainPage());
              case 'article-category-page':
                final category = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (_) => ArticleCategoryPage(category: category),
                  settings: settings,
                );
              case 'article-detail-page':
                final article = settings.arguments as Article;
                return MaterialPageRoute(
                  builder: (_) => DetailPage(article: article),
                  settings: settings,
                );
              case 'article-webview-page':
                final url = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (_) => ArticleWebviewPage(url: url),
                  settings: settings,
                );
              default:
                return MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    body: Center(
                      child: Text('Halaman Tidak Ditemukan :('),
                    ),
                  );
                });
            }
          }),
    );
  }
}
