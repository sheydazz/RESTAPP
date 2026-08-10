import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  bool _isPlaying = false;
  int _selectedPlaylist = 0;

  final List<Map<String, String>> playlists = [
    {'name': 'Relajación', 'songs': '12 canciones'},
    {'name': 'Meditación', 'songs': '8 canciones'},
    {'name': 'Zen', 'songs': '15 canciones'},
    {'name': 'Musicoterapia', 'songs': '10 canciones'},
  ];

  final List<String> songs = [
    'Serenidad en el Bosque',
    'Lluvia Suave',
    'Océano Tranquilo',
    'Atardecer Rosa',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        title: Text(
          '🎵 Música',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reproductor
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'Ahora reproduciendo:',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: () => setState(() => _isPlaying = !_isPlaying),
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      songs[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // Playlists
              Text(
                'Mis Playlists:',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              ...List.generate(
                playlists.length,
                (index) => GestureDetector(
                  onTap: () => setState(() => _selectedPlaylist = index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedPlaylist == index
                          ? const Color(0xFF9C27B0).withValues(alpha: 0.2)
                          : colorScheme.surfaceContainerLow,
                      border: Border.all(
                        color: _selectedPlaylist == index
                            ? const Color(0xFF9C27B0)
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.playlist_play,
                          color: Color(0xFF9C27B0),
                          size: 24,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playlists[index]['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                playlists[index]['songs']!,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF9C27B0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Canciones
              Text(
                'Canciones en ${playlists[_selectedPlaylist]['name']}:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              ...List.generate(
                songs.length,
                (index) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.music_note,
                        color: Color(0xFF9C27B0),
                        size: 20,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          songs[index],
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                      const Icon(
                        Icons.play_arrow,
                        color: Color(0xFF9C27B0),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
