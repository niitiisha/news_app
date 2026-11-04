import 'package:flutter/material.dart';

import 'screens/headlines_page.dart';
import 'screens/search_page.dart';
import 'services/news_service.dart';

import 'package:firebase_core/firebase_core.dart';

import 'services/analytics_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const NewsApp());
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

  final NewsService newsService = NewsService(
    'a82d25e8386448c3b72abec0d3d9f163',
  );
  final AnalyticsService analyticsService = AnalyticsService();

  @override
  void initState() {
    super.initState();
    analyticsService.logAppLaunched();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News App')),

      body: IndexedStack(
        index: selectedIndex,
        children: [
          HeadlinesPage(
            newsService: newsService,
            analyticsService: analyticsService,
          ),
          SearchPage(
            newsService: newsService,
            analyticsService: analyticsService,
          ),
        ],
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
        ],
      ),
    );
  }
}
