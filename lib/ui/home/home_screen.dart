import 'package:flutter/material.dart';
import 'package:movies_app/ui/home/tabs/browse/browse_tab.dart';
import 'package:movies_app/ui/home/tabs/home/home_tab.dart';
import 'package:movies_app/ui/home/tabs/profile/profile_tab.dart';
import 'package:movies_app/ui/home/tabs/search/search_tab.dart';
import 'package:movies_app/widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  String? browseGenre; // currently selected genre

  void onTabSelected(int index, {String? genre}) {
    setState(() {
      currentIndex = index;
      if (genre != null) {
        browseGenre = genre; // update currently selected genre
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTab(onSeeMore: (genre) {
        // send genre and index of browse tab
        onTabSelected(2, genre: genre);
      }),
      const SearchTab(),
      BrowseTab(selectedGenre: browseGenre), // pass currently selected genre
      const ProfileTab(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTabSelected: (i) => onTabSelected(i),
      ),
    );
  }
}

