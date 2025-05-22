import 'package:flutter/material.dart';
import '../views/home/home_page.dart';
import '../views/explore/explore_page.dart';
import '../views/library/library_page.dart';
import '../views/profile/profile_page.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = [
    HomePage(),
    ExplorePage(),
    LibraryPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),

        // 🔁 PageView mit besserem Swipe-Verhalten
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: _pages.length,
          itemBuilder: (context, index) => _pages[index],
          physics: const ClampingScrollPhysics(), // <- besseres Einrasten
          pageSnapping: true,
        ),

        // ⬇️ Bottom Navigation Bar
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF181818),
            border: Border(top: BorderSide(color: Colors.black26, width: 0.3)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  final icons = [
                    Icons.home_outlined,
                    Icons.search_outlined,
                    Icons.library_music_outlined,
                    Icons.person_outline,
                  ];
                  final labels = ['Home', 'Explore', 'Library', 'Profile'];

                  final isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () => _onItemTapped(index),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icons[index],
                          size: 28,
                          color:
                              isSelected
                                  ? const Color(0xFF1DB954)
                                  : const Color(0xFFB3B3B3),
                        ),
                        const SizedBox(height: 4),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isSelected ? 1 : 0,
                          child: Text(
                            labels[index],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1DB954),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
