import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_feed_app/core/routes/routes.dart';
import 'package:video_feed_app/screens/home/view/widget/category_list_widget.dart';

import '../../../core/util/app_color.dart';
import '../../../core/util/common_widgets.dart';
import '../view_model/home_provider.dart';
import 'widget/feed_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).getHomeData();
      Provider.of<HomeProvider>(context, listen: false).getCategoryData();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Stop any playing video when disposing
    Provider.of<HomeProvider>(context, listen: false).stopCurrentVideo();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final provider = Provider.of<HomeProvider>(context, listen: false);

    // Pause video when app goes to background
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      provider.pauseVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () => context.read<HomeProvider>().refreshData(),
        child: SingleChildScrollView(child: Column(children: [const CategoryList(), _buildContent()])),
      ),
      floatingActionButton: _buildFlottingActionButton(context),
    );
  }

  /// Builds the custom AppBar with dynamic user data
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 100,
      title: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeletonizer(
                effect: ShimmerEffect(baseColor: const Color(0xff1F1F1F), highlightColor: const Color(0xff2F2F2F)),
                enabled: provider.isLoading,
                child: text(
                  text: provider.isLoading ? 'Hello User' : provider.getUserGreeting(),
                  size: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.white,
                ),
              ),
              const SizedBox(height: 12),
              text(
                text: 'Welcome back to Section',
                size: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xffD5D5D5),
                letterSpacing: 1.3,
              ),
            ],
          );
        },
      ),
      actions: [
        Consumer<HomeProvider>(
          builder: (context, provider, child) {
            final userImage = provider.user?.image?.toString();
            return Skeletonizer(
              effect: ShimmerEffect(baseColor: const Color(0xff1F1F1F), highlightColor: const Color(0xff2F2F2F)),
              enabled: provider.isLoading,
              child: image(
                url: (userImage != null && userImage.isNotEmpty) ? userImage : 'https://picsum.photos/300/200',
                height: 47.16,
                width: 47.16,
                borderRadius: BorderRadius.circular(100),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildContent() {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.hasError && !provider.isLoading) {
          return _buildErrorState();
        }

        if (provider.isEmpty) {
          return _buildEmptyState();
        }

        return _buildFeedList();
      },
    );
  }

  Widget _buildFeedList() {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Skeletonizer(
          effect: ShimmerEffect(baseColor: const Color(0xff1F1F1F), highlightColor: const Color(0xff2F2F2F)),
          enabled: provider.isLoading,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.isLoading ? 3 : provider.feeds.length,
            separatorBuilder: (_, __) => Divider(color: AppColor.black, thickness: 3),
            itemBuilder: (context, index) {
              if (provider.isLoading) {
                return FeedWidget(feedIndex: index);
              }
              return FeedWidget(feed: provider.feeds[index], feedIndex: index);
            },
          ),
        );
      },
    );
  }

  /// Builds the empty state when no feeds are available
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 180),
          Icon(Icons.video_library_outlined, size: 80, color: AppColor.white.withOpacity(0.3)),
          const SizedBox(height: 20),
          text(text: 'No Feeds Available', size: 20, fontWeight: FontWeight.w600, color: AppColor.white),
          const SizedBox(height: 10),
          text(
            text: 'Be the first to share something interesting!',
            size: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xffD5D5D5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addFeedsView);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffC70000),
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: text(text: 'Create First Post', size: 16, fontWeight: FontWeight.w500, color: AppColor.white),
          ),
        ],
      ),
    );
  }

  /// Builds the error state
  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 180),
          Icon(Icons.error_outline, size: 80, color: Colors.red.withOpacity(0.7)),
          const SizedBox(height: 20),
          text(text: 'Something went wrong', size: 20, fontWeight: FontWeight.w600, color: AppColor.white),
          const SizedBox(height: 10),
          text(
            text: 'Please check your connection and try again',
            size: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xffD5D5D5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.read<HomeProvider>().refreshData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffC70000),
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: text(text: 'Try Again', size: 16, fontWeight: FontWeight.w500, color: AppColor.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFlottingActionButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.addFeedsView);
      },
      child: CircleAvatar(
        radius: 34,
        backgroundColor: const Color(0xffC70000),
        child: Icon(Icons.add, color: AppColor.white, size: 40),
      ),
    );
  }
}
