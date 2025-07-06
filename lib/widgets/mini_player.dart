import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicProvider>(context);

    if (provider.currentSong == null) return const SizedBox();

    final song = provider.currentSong!;

    return Container(
      color: Colors.blueGrey[900],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          QueryArtworkWidget(
            id: song.id,
            type: ArtworkType.AUDIO,
            artworkBorder: BorderRadius.circular(8),
            nullArtworkWidget: const Icon(Icons.music_note, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              song.title.length > 30 ? '${song.title.substring(0, 30)}...' : song.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(
              provider.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              provider.isPlaying ? provider.pause() : provider.resume();
            },
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: () => provider.playNext(),
          ),
        ],
      ),
    );
  }
}
