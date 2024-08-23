// category_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryNavBar extends StatelessWidget {
  final Function(String) onCategorySelected;
  final String categorySelected;

  CategoryNavBar(
      {super.key,
      required this.onCategorySelected,
      required this.categorySelected});

  Widget _buildCategoryItem(String category, {bool isHighlighted = false}) {
    bool isSelected = categorySelected == category;
    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: Column(
        children: [
          Text(
            category,
            style: TextStyle(
              color: isHighlighted ? Colors.yellow : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 2),
              height: 2.h,
              width: 15.w,
              color: Colors.yellow,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCategoryItem('All'),
        _buildCategoryItem('Men'),
        _buildCategoryItem('Women'),
        _buildCategoryItem('Electronics'),
        _buildCategoryItem('Jewelery'),
      ],
    );
  }
}
