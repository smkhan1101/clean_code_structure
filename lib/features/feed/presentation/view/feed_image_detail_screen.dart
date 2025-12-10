import 'package:startup_repo/imports.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedImageDetailScreen extends StatelessWidget {
  final String? uri;
  
  const FeedImageDetailScreen({super.key, this.uri});

  @override
  Widget build(BuildContext context) {
    final imageUri = Get.arguments?['uri'] ?? uri ?? '';
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: imageUri,
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(Iconsax.image, color: Colors.white, size: 64.sp),
                ),
              ),
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

