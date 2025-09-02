import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';

class CustomGenresTabItem extends StatelessWidget {
  final bool isSelected;
  final String eventName;
  final Color selectedBgColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unSelectedTextStyle;
  final Color? borderColor;
  
  const CustomGenresTabItem({
    super.key,
    required this.isSelected,
    required this.eventName,
    required this.selectedBgColor,
    required this.selectedTextStyle,
    required this.unSelectedTextStyle,
    this.borderColor,
    
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.01),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.006,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? Theme.of(context).focusColor,
          width: 2,
        ),
        color: isSelected ? selectedBgColor : AppColors.transparent,
      ),
      child: Text(
        eventName,
        style: isSelected ? selectedTextStyle : unSelectedTextStyle,
      ),
    );
  }
}
