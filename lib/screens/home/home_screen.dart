import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../providers/music_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;

  final List<String> categories = [
    '🎵 Songs',
    '💿 Albums',
    '👤 Artists',
    '📁 Playlists',
    '📂 Folders',
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<MusicProvider>(context, listen: false).loadMusicData();
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("BlueBeat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Settings tapped")));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, Listener 👋", style: AppTextStyles.headline),
            const SizedBox(height: 16),

            // 🔍 Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.white54),
                  hintText: 'Search songs...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🔘 Category chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  final selected = selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedCategoryIndex = index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primaryBlue
                            : AppColors.primaryBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryBlue),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 📦 Content area
            Expanded(child: _buildCategoryContent(musicProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryContent(MusicProvider provider) {
    switch (selectedCategoryIndex) {
      case 0: // 🎵 Songs
        if (provider.songs.isEmpty) {
          return Center(child: Text(provider.status, style: AppTextStyles.subtext));
        }
        return ListView.builder(
          itemCount: provider.songs.length,
          itemBuilder: (_, index) {
            final song = provider.songs[index];
            return ListTile(
              leading: QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(Icons.music_note, color: Colors.white),
              ),
              title: Text(
                song.title.length > 50 ? "${song.title.substring(0, 50)}..." : song.title,
                style: AppTextStyles.body,
              ),
              subtitle: Text(song.artist ?? 'Unknown', style: AppTextStyles.subtext),
              trailing: const Icon(Icons.play_arrow, color: Colors.white),
            );
          },
        );

      case 1: // 💿 Albums
        if (provider.albums.isEmpty) {
          return Center(child: Text("No albums found", style: AppTextStyles.subtext));
        }
        return ListView.builder(
          itemCount: provider.albums.length,
          itemBuilder: (_, index) {
            final album = provider.albums[index];
            return ListTile(
              leading: QueryArtworkWidget(
                id: album.id,
                type: ArtworkType.ALBUM,
                nullArtworkWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/images/sample_album.jpg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(album.album, style: AppTextStyles.body),
              subtitle: Text(album.artist ?? '', style: AppTextStyles.subtext),
            );
          },
        );

      case 2: // 👤 Artists
        if (provider.artists.isEmpty) {
          return Center(child: Text("No artists found", style: AppTextStyles.subtext));
        }
        return ListView.builder(
          itemCount: provider.artists.length,
          itemBuilder: (_, index) {
            final artist = provider.artists[index];
            return ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: Text(artist.artist, style: AppTextStyles.body),
              subtitle:
              Text("${artist.numberOfTracks} tracks", style: AppTextStyles.subtext),
            );
          },
        );

      case 3: // 📁 Playlists
        if (provider.playlists.isEmpty) {
          return Center(child: Text("No playlists found", style: AppTextStyles.subtext));
        }
        return ListView.builder(
          itemCount: provider.playlists.length,
          itemBuilder: (_, index) {
            final playlist = provider.playlists[index];
            return ListTile(
              leading: const Icon(Icons.queue_music, color: Colors.white),
              title: Text(playlist.playlist, style: AppTextStyles.body),
              subtitle:
              Text("${playlist.numOfSongs} songs", style: AppTextStyles.subtext),
            );
          },
        );

      case 4: // 📂 Folders (placeholder)
        return const Center(
          child: Text("Folder view coming soon", style: TextStyle(color: Colors.white70)),
        );

      default:
        return const SizedBox();
    }
  }
}
