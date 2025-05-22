import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Your top genres',
      'items': [
        {'label': 'Pop', 'color': Color(0xFF9B51E0)},
        {'label': 'Indie', 'color': Color(0xFF6FCF97)},
      ],
    },
    {
      'title': 'Popular podcast categories',
      'items': [
        {'label': 'News & Politics', 'color': Color(0xFF2D9CDB)},
        {'label': 'Comedy', 'color': Color(0xFFEB5757)},
      ],
    },
    {
      'title': 'Browse all',
      'items': [
        {'label': '2021 Wrapped', 'color': Color(0xFFE0E267)},
        {'label': 'Podcasts', 'color': Color(0xFF2F80ED)},
        {'label': 'Made for you', 'color': Color(0xFF27AE60)},
        {'label': 'Charts', 'color': Color(0xFFBB6BD9)},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text('Search', style: TextStyle(color: Colors.white)),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.camera_alt_outlined, color: Colors.white),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔍 Search Bar
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              hintText: 'Artists, songs, or podcasts',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 📚 Sections
          ...sections.map((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.7,
                  children: List.generate(section['items'].length, (index) {
                    final item = section['items'][index];
                    return Container(
                      decoration: BoxDecoration(
                        color: item['color'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              item['label'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.album,
                                color: Colors.black45,
                                size: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 28),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
