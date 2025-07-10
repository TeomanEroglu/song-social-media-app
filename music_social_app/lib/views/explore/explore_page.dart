import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/explore_songs_provider.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExploreSongsProvider(),
      child: const _ExploreView(),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView({super.key});

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;          


  final _controller = TextEditingController();
  final _focusNode  = FocusNode();
  bool  _searchMode = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() => _searchMode = true);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final trimmed = query.trim();
      if (trimmed.isEmpty) {
        context.read<ExploreSongsProvider>().reset();
        return;
      }
      context.read<ExploreSongsProvider>().loadInitial(trimmed);
    });
  }

  void _exitSearch() {
    _controller.clear();
    _focusNode.unfocus();
    context.read<ExploreSongsProvider>().reset();
    setState(() => _searchMode = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);                  
    final state = context.watch<ExploreSongsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        leading: _searchMode
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _exitSearch,
              )
            : null,
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
              focusNode: _focusNode,
              onChanged: _onQueryChanged,
              onSubmitted: _onQueryChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  _searchMode ? Icons.search : Icons.search_outlined,
                  color: Colors.white54,
                ),
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
            Expanded(
              child: _searchMode
                  ? _SongList(state: state)
                  : const _CategoryGrid(),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------- GRID with 6 Categories (only UI) ----------------------------
class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid();

  static final _items = [
    ('Release Radar', Color(0xFF1DB954)),
    ('For You',       Color(0xFF5353F2)),
    ('Charts',        Color(0xFFE040FB)),
    ('Rock',          Color(0xFFFF7043)),
    ('Pop',           Color(0xFF29B6F6)),
    ('HipHop',        Color(0xFFFFCA28)),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,               
      children: _items.map((e) {
        final title = e.$1;
        final color = e.$2;
        return GestureDetector(
          onTap: () =>
              context.read<ExploreSongsProvider>().loadInitial(title),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Positioned(
                  right: 8,
                  bottom: 8,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.album,
                        color: Colors.black45, size: 36),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// ------------- SONG-LIST -------------------------------------------------
class _SongList extends StatelessWidget {
  final ExploreSongsProvider state;
  const _SongList({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(
          child: Text(state.error!, style: const TextStyle(color: Colors.white70)));
    }
    if (state.songs.isEmpty) {
      return const Center(
          child: Text('No results', style: TextStyle(color: Colors.white70)));
    }
    return ListView.builder(
      itemCount: state.songs.length,
      itemBuilder: (_, i) {
        final song = state.songs[i];
        return ListTile(
          leading: song.albumImageUrl != null
              ? Image.network(song.albumImageUrl!,
                  width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.music_note, color: Colors.white70),
          title: Text(song.title, style: const TextStyle(color: Colors.white)),
          subtitle:
              Text(song.artist, style: const TextStyle(color: Colors.white70)),
        );
      },
    );
  }
}
