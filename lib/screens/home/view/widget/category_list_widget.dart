import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/util/app_color.dart';
import '../../view_model/home_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final List<Map<String, dynamic>> defaultCategories = [
          {'name': 'Explore', 'icon': 'assets/image/ExplorePng.png'},
          {'name': 'Sports'},
          {'name': 'Music'},
          {'name': 'News'},
          {'name': 'Movies'},
        ];

        final List<Map<String, dynamic>> displayCategories = [];

        if (provider.categories.isNotEmpty) {
          displayCategories.add({'name': 'Explore', 'icon': 'assets/image/ExplorePng.png'});

          for (var category in provider.categories) {
            displayCategories.add({'name': category.title ?? 'Unknown', 'image': category.image, 'id': category.id});
          }
        } else if (!provider.isCategoryLoading) {
          displayCategories.addAll(defaultCategories);
        } else {
          displayCategories.addAll(defaultCategories);
        }

        return SizedBox(
          height: 35,
          child: Skeletonizer(
            effect: ShimmerEffect(baseColor: const Color(0xff1F1F1F), highlightColor: const Color(0xff2F2F2F)),

            enabled: provider.isCategoryLoading,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: displayCategories.length,
              separatorBuilder: (context, index) {
                if (index == 0) {
                  return Row(
                    children: [
                      const SizedBox(width: 10),
                      Container(width: 1, height: 20, color: Colors.grey.withOpacity(0.5)),
                      const SizedBox(width: 10),
                    ],
                  );
                }
                return const SizedBox(width: 10);
              },
              itemBuilder: (context, index) {
                return Selector<HomeProvider, int>(
                  selector: (_, provider) => provider.selectedCategoryIndex,
                  builder: (_, selectedIndex, __) {
                    final isSelected = selectedIndex == index;
                    final category = displayCategories[index];

                    return GestureDetector(
                      onTap: () {
                        context.read<HomeProvider>().selectCategory(index);
                        print('Selected category: ${category['name']} at index: $index');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xffC70000).withOpacity(0.2)
                                : AppColor.white.withOpacity(0.28),
                          ),
                          color: isSelected ? const Color(0xffC70000).withOpacity(0.4) : const Color(0xff1F1F1F),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              if (index == 0) ...[
                                Image.asset(
                                  category['icon'] ?? 'assets/image/ExplorePng.png',
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.explore, color: AppColor.white, size: 16);
                                  },
                                ),
                                const SizedBox(width: 8),
                              ] else if (category['image'] != null) ...[
                                Image.network(
                                  category['image'],
                                  width: 16,
                                  height: 16,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.category, color: AppColor.white, size: 16);
                                  },
                                ),
                                const SizedBox(width: 8),
                              ],
                            ],
                            Text(category['name'], style: const TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
