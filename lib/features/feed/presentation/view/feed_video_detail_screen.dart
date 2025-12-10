import 'dart:convert';
import 'package:startup_repo/imports.dart';

class FeedVideoDetailScreen extends StatelessWidget {
  final String? uri;
  
  const FeedVideoDetailScreen({super.key, this.uri});

  @override
  Widget build(BuildContext context) {
    String videoUri = Get.arguments?['uri'] ?? uri ?? '';
    
    try {
      final decodedBytes = base64Decode(videoUri);
      videoUri = utf8.decode(decodedBytes);
    } catch (e) {
      // If decoding fails, use original URI
    }
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.video, color: Colors.white, size: 64.sp),
                SizedBox(height: 16.sp),
                Text(
                  'video_player_coming_soon'.tr,
                  style: context.font16.copyWith(color: Colors.white),
                ),
                SizedBox(height: 8.sp),
                Text(
                  videoUri,
                  style: context.font12.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: IconButton(
                icon: Icon(Iconsax.close_circle, color: Colors.white, size: 32.sp),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

