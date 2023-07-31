import 'package:flutter/material.dart';
import 'package:flutter_study_app/configs/themes/app_icons.dart';
import 'package:flutter_study_app/configs/themes/custom_text_styles.dart';
import 'package:flutter_study_app/configs/themes/ui_parameteres.dart';
import 'package:flutter_study_app/widgets/app_circle_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final Widget? leadingWidget;
  final bool showActionIcon;
  final VoidCallback? onMenuActionTap;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.titleWidget,
    this.leadingWidget,
    this.showActionIcon = false,
    this.onMenuActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mobileScreenPadding, vertical: mobileScreenPadding),
      child: Stack(
        children: [
          Positioned.fill(
            child: titleWidget == null
                ? Center(
                    child: Text(
                      title,
                      style: appBarTS,
                    ),
                  )
                : Center(
                    child: titleWidget,
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leadingWidget ??
                  Transform.translate(
                    offset: const Offset(-14, 0),
                    child: const BackButton(),
                  ),
              if (showActionIcon)
                Transform.translate(
                  offset: const Offset(10, 0),
                  child: AppCircleButton(
                    child: const Icon(AppIcons.menuLeft),
                    onTap: onMenuActionTap ?? null,
                  ),
                )
            ],
          )
        ],
      ),
    ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.maxFinite, 80);
}
