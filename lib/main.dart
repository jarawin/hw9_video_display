import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hw9_video_display/video_player_page.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class VideoData {
  String fileName;
  String videoLink;
  String uploadTime;
  String profileLink;

  VideoData(this.fileName, this.videoLink, this.uploadTime, this.profileLink);
}

List MOCK_VIDEO_DATA = [
  VideoData(
    'BigBuckBunny.mp4',
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    '6 hours ago',
    'https://i.ibb.co/TtyrtYs/profile.jpg',
  ),
  VideoData(
    'ElephantsDream.mp4',
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    '6 days ago',
    'https://i.ibb.co/TtyrtYs/profile.jpg',
  ),
  VideoData(
    'ForBiggerBlazes.mp4',
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    'just now',
    'https://i.ibb.co/TtyrtYs/profile.jpg',
  ),
  VideoData(
    'ForBiggerEscapes.mp4',
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    '43 minutes ago',
    'https://i.ibb.co/TtyrtYs/profile.jpg',
  ),
  VideoData(
    'ForBiggerFun.mp4',
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    '4 hours ago',
    'https://i.ibb.co/TtyrtYs/profile.jpg',
  ),
  VideoData(
    'ForBiggerJoyrides.mp4',
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    '23 minutes ago',
    'https://i.ibb.co/TtyrtYs/profile.jpg',
  ),
];

void main() {
  runApp(const MaterialApp(home: VideoList()));
}

class VideoList extends StatelessWidget {
  const VideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video List'),
      ),
      body: ListView.builder(
        itemCount: MOCK_VIDEO_DATA.length,
        itemBuilder: (context, index) {
          VideoData videoData = MOCK_VIDEO_DATA[index];
          return Column(
            children: [
              // video thumbnail
              SizedBox(
                height: 200,
                child: ThumbnailImage(
                  videoLink: videoData.videoLink,
                ),
              ),

              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(videoData.profileLink),
                ),
                title: Text(videoData.fileName),
                subtitle: Text(videoData.uploadTime),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreenState(
                        videoLink: videoData.videoLink,
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}

class ThumbnailImage extends StatefulWidget {
  final String videoLink;
  const ThumbnailImage({super.key, required this.videoLink});

  @override
  State<ThumbnailImage> createState() => _ThumbnailImageState();
}

class _ThumbnailImageState extends State<ThumbnailImage> {
  String? _thumbnailUrl;

  @override
  void initState() {
    super.initState();
    generateThumbnail();
  }

  void generateThumbnail() async {
    Directory tempDir = await getTemporaryDirectory();

    _thumbnailUrl = await VideoThumbnail.thumbnailFile(
        video: widget.videoLink,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.WEBP);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _thumbnailUrl == null
        ? const CircularProgressIndicator()
        : Image.file(File(_thumbnailUrl!));
  }
}
