import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_feed_app/core/util/common_widgets.dart';

import '../../view_model/add_feeds_provider.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['Sports', 'Music', 'News', 'Movies', 'Tech', 'Travel'];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(categories.length, (index) {
        return Selector<AddFeedsProvider, bool>(
          selector: (_, provider) => provider.selectedCategories.contains(index),
          builder: (context, isSelected, __) {
            return GestureDetector(
              onTap: () => context.read<AddFeedsProvider>().toggleCategory(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xffC70000).withOpacity(0.4) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xffC70000).withOpacity(isSelected ? 1.0 : 0.4), width: 0.62),
                ),
                child: text(text: categories[index], size: 12, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            );
          },
        );
      }),
    );
  }
}
