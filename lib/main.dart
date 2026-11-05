import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // NEW
import 'package:provider/provider.dart';

import 'providers/bookmark_provider.dart';
import 'providers/news_provider.dart';
import 'screens/bookmarks_page.dart';
import 'screens/headlines_page.dart';
import 'screens/search_page.dart';
import 'services/analytics_service.dart';
import 'services/news_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NEW: load the .env file before anything uses the key
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp();

  // CHANGED: key comes from .env instead of being hard-coded
  final apiKey = dotenv.env['NEWS_API_KEY'] ?? '';

  final newsService = NewsService(apiKey);
  final analyticsService = AnalyticsService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(
            newsService: newsService,
            analyticsService: analyticsService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarkProvider()..loadBookmarks(),
        ),
      ],
      child: const NewsApp(),
    ),
  );
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<NewsProvider>().analyticsService.logAppLaunched();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News App')),
      body: IndexedStack(
        index: selectedIndex,
        children: const [HeadlinesPage(), SearchPage(), BookmarksPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Headlines',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }
}
