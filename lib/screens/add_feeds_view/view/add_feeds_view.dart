import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_feed_app/core/util/app_color.dart';
import 'package:video_feed_app/core/util/common_widgets.dart';
import 'package:video_feed_app/core/util/responsive.dart';
import 'package:video_feed_app/core/util/sized_box.dart';

import '../view_model/add_feeds_provider.dart';
import 'widget/category_selector_widget.dart';
import 'widget/custom_dotted_container.dart';

class AddFeedsView extends StatelessWidget {
  const AddFeedsView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddFeedsProvider>();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizeBoxH(Responsive.height * 6),
          _buildHeader(context, provider),
          SizeBoxH(10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizeBoxH(30),
                  _buildVideoPicker(provider),
                  SizeBoxH(40),
                  _buildThumbnailPicker(provider),
                  SizeBoxH(32),
                  text(text: 'Add Description', size: 16, fontWeight: FontWeight.w600, color: AppColor.white),
                  SizeBoxH(12),
                  _buildDescriptionField(provider),
                  Divider(color: const Color(0xff515151), thickness: 0.21),
                  SizeBoxH(12),
                  _buildCategoryHeader(),
                  SizeBoxH(20),
                  const CategorySelector(),
                  SizeBoxH(100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AddFeedsProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.white),
                borderRadius: BorderRadius.circular(100),
              ),
              margin: const EdgeInsets.only(right: 20),
              child: Icon(Icons.arrow_back_ios_new_outlined, color: AppColor.white, size: 12),
            ),
          ),
          text(text: 'Add Feeds', size: 16, fontWeight: FontWeight.w600, color: AppColor.white),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              // Show validation error if form is invalid
              if (!provider.validateForm()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields'), backgroundColor: Colors.red),
                );
                return;
              }

              // Call the API
              try {
                final success = await provider.addFeedFn();

                if (success) {
                  provider.clearFields();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feed added successfully!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    await Future.delayed(const Duration(milliseconds: 500));
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                } else {
                  // Show error message
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to add feed. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } catch (e) {
                // Handle any unexpected errors
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An error occurred: ${e.toString()}'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: const Color(0xffC70000).withOpacity(0.2)),
                color: const Color(0xffC70000).withOpacity(0.4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              child: provider.isSharePostLoading
                  ? const SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : text(text: 'Share Post', size: 13, fontWeight: FontWeight.w400, color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPicker(AddFeedsProvider provider) {
    return GestureDetector(
      onTap: provider.isSharePostLoading ? null : provider.pickVideo,
      child: CustomDottedContainer(
        child: SizedBox(
          width: double.infinity,
          height: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image/gallery-add.png', height: 55, width: 55),
              SizeBoxH(20),
              text(
                text: provider.videoFile != null
                    ? _shortenFileName(provider.videoFile!.path)
                    : 'Select a video from Gallery',
                size: 15,
                fontWeight: FontWeight.w400,
                color: AppColor.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailPicker(AddFeedsProvider provider) {
    return GestureDetector(
      onTap: provider.isSharePostLoading ? null : provider.pickThumbnail,
      child: CustomDottedContainer(
        child: SizedBox(
          width: double.infinity,
          height: 128,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image/thumbnailAdd.png', height: 20, width: 32),
              SizeBoxV(50),
              text(
                text: provider.thumbnailFile != null ? _shortenFileName(provider.thumbnailFile!.path) : 'Thumbnail',
                size: 15,
                fontWeight: FontWeight.w400,
                color: AppColor.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionField(AddFeedsProvider provider) {
    return TextFormField(
      enabled: !provider.isSharePostLoading,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      maxLines: null,
      onChanged: (val) => provider.description = val,
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: 'Type your description here...',
        hintStyle: TextStyle(color: Color(0xff9E9E9E), fontSize: 14),
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return Row(
      children: [
        text(text: 'Categories This Project', size: 16, fontWeight: FontWeight.w600, color: AppColor.white),
        const Spacer(),
        text(text: 'View All', size: 10, fontWeight: FontWeight.w600, color: const Color(0xffD5D5D5)),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.white),
            borderRadius: BorderRadius.circular(100),
          ),
          margin: const EdgeInsets.only(left: 20),
          child: Icon(Icons.arrow_forward_ios_rounded, color: AppColor.white, size: 12),
        ),
      ],
    );
  }

  String _shortenFileName(String path) {
    final name = path.split('/').last;
    if (name.length > 20) {
      return '${name.substring(0, 10)}...${name.substring(name.length - 7)}';
    }
    return name;
  }
}
