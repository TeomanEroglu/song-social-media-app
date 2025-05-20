import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';
import 'library_data.dart';
import 'song_detail_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

// Static Genres/Filters -> Later Dynamic ?! ////////////////////
class _LibraryPageState extends State<LibraryPage> {
  String searchTerm = '';
  String selectedGenre = 'All';
  String selectedCountry = 'All';
  String selectedArtist = 'All';
  String selectedYear = 'All';

  late final List<Map<String, String>> songs = testSongs;

  final List<String> genres = ['All', 'Pop', 'Rock'];
  final List<String> countries = ['All', 'USA', 'Canada', 'UK'];
  final List<String> artists = [
    'All',
    'Red Hot Chili Peppers',
    'The Weeknd',
    'Harry Styles',
  ];
  final List<String> years = ['All', '1999', '2019', '2020'];

  ////////////////////////////////////////////////////////////////

  // Filter Logic
  List<Map<String, String>> get filteredSongs {
    return songs.where((song) {
      return (searchTerm.isEmpty ||
              song['title']!.toLowerCase().contains(
                searchTerm.toLowerCase(),
              )) &&
          (selectedGenre == 'All' || song['genre'] == selectedGenre) &&
          (selectedCountry == 'All' || song['country'] == selectedCountry) &&
          (selectedArtist == 'All' || song['artist'] == selectedArtist) &&
          (selectedYear == 'All' || song['year'] == selectedYear);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Library'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search songs...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) => setState(() => searchTerm = val),
            ),
            const SizedBox(height: 16),

            // Filter Dropdowns
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        'Genre',
                        genres,
                        selectedGenre,
                        (val) => setState(() => selectedGenre = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown(
                        'Artist',
                        artists,
                        selectedArtist,
                        (val) => setState(() => selectedArtist = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        'Country',
                        countries,
                        selectedCountry,
                        (val) => setState(() => selectedCountry = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown(
                        'Year',
                        years,
                        selectedYear,
                        (val) => setState(() => selectedYear = val),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Result List
            Expanded(
              child: ListView.builder(
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  final song = filteredSongs[index];
                  return ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(song['title']!),
                    subtitle: Text(
                      '${song['artist']} • ${song['genre']} • ${song['year']}',
                    ),
                    trailing: Text(song['country']!),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongDetailPage(song: song),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String current,
    Function(String) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: current,
      items:
          options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
      onChanged: (val) => onChanged(val!),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
    );
  }
}
