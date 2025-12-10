import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:startup_repo/imports.dart';
import '../controller/feed_controller.dart';
import '../../../../core/widgets/loading.dart';

class PostFeedScreen extends StatefulWidget {
  const PostFeedScreen({super.key});

  @override
  State<PostFeedScreen> createState() => _PostFeedScreenState();
}

class _PostFeedScreenState extends State<PostFeedScreen> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      showToast('error_picking_image'.tr);
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      showToast('error_taking_photo'.tr);
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Iconsax.camera),
              title: Text('take_photo'.tr),
              onTap: () {
                Get.back();
                _takePhoto();
              },
            ),
            ListTile(
              leading: Icon(Iconsax.gallery),
              title: Text('choose_from_gallery'.tr),
              onTap: () {
                Get.back();
                _pickImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _postFeed() async {
    if (_textController.text.isEmpty && _selectedImage == null) {
      showToast('enter_text_or_select_image'.tr);
      return;
    }

    final controller = Get.find<FeedController>();
    setState(() {
      _isUploading = true;
    });

    try {
      String attachmentPath = '';
      if (_selectedImage != null) {
        attachmentPath = await controller.feedService.uploadFile(_selectedImage!.path);
      }
      
      await controller.sendPost(_textController.text, attachmentPath);
      Get.back();
    } catch (e) {
      showToast('error_creating_post'.tr);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create_post'.tr),
        leading: IconButton(
          icon: Icon(Iconsax.close_circle),
          onPressed: () => Get.back(),
        ),
        actions: [
          if (_isUploading)
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Loading(size: 20),
            )
          else
            TextButton(
              onPressed: _postFeed,
              child: Text(
                'post'.tr,
                style: context.font16.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _textController,
              hintText: 'write_something'.tr,
              maxLines: 5,
            ),
            SizedBox(height: 20.sp),
            if (_selectedImage != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.sp),
                    child: Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      height: 200.sp,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8.sp,
                    right: 8.sp,
                    child: IconButton(
                      icon: Icon(Iconsax.close_circle, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20.sp),
            Row(
              children: [
                IconButton(
                  icon: Icon(Iconsax.gallery_add),
                  onPressed: _showImageSourceDialog,
                ),
                Text('add_attachment'.tr, style: context.font14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

