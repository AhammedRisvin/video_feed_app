import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/app_color.dart';
import '../../view_model/home_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Explore', 'icon': 'assets/image/ExplorePng.png'},
      {'name': 'Sports'},
      {'name': 'Music'},
      {'name': 'News'},
      {'name': 'Movies'},
    ];
    return SizedBox(
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: categories.length,
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
              final category = categories[index];
              return GestureDetector(
                onTap: () => context.read<HomeProvider>().selectCategory(index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: isSelected ? Color(0xffC70000).withOpacity(0.2) : AppColor.white.withOpacity(0.28),
                    ),
                    color: isSelected ? Color(0xffC70000).withOpacity(0.4) : const Color(0xff1F1F1F),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        Image.asset(category['icon'] ?? 'assets/image/ExplorePng.png'),
                        const SizedBox(width: 8),
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
    );
  }
}
