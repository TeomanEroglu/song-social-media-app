import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/explore_songs_provider.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExploreSongsProvider(),        // ⚠️  keine Initialsuche
      child: const _ExploreView(),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView({super.key});

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final trimmed = query.trim();
      if (trimmed.isEmpty) {
        // leeren Zustand anzeigen
        context.read<ExploreSongsProvider>().reset();
        return;
      }
      context.read<ExploreSongsProvider>().loadInitial(trimmed);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ExploreSongsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _onQueryChanged,
              onSubmitted: _onQueryChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                hintText: 'Search tracks',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildBody(state)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ExploreSongsProvider state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(
        child: Text(state.error!, style: const TextStyle(color: Colors.white70)),
      );
    }
    if (state.songs.isEmpty) {
      // weder Fehlermeldung noch Ergebnisse → einfach leer
      return const SizedBox.shrink();
    }
    return ListView.builder(
      itemCount: state.songs.length,
      itemBuilder: (_, i) {
        final song = state.songs[i];
        return ListTile(
          leading: song.albumImageUrl != null
              ? Image.network(
                  song.albumImageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.music_note, color: Colors.white70),
          title:
              Text(song.title, style: const TextStyle(color: Colors.white)),
          subtitle:
              Text(song.artist, style: const TextStyle(color: Colors.white70)),
        );
      },
    );
  }
}
