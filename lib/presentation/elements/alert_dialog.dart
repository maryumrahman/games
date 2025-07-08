import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:games/infrastructure/utils/extensions.dart';
import '../../../../../generated/assets.dart';
import '../../infrastructure/routes/navigation_helper.dart';
import 'app_text.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String? subtitle;

  const AppAlertDialog({super.key,
    required this.title,
    required this.text,
    this.onConfirm,
    this.onCancel,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
        title: Text(title),
        backgroundColor: context.colorScheme.surface,
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(12))),
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  onPressed: onCancel?? () {
                    NavigationHelper.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ),
              20.width,
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  onPressed: onConfirm?? () {
                    NavigationHelper.pop(context);
                  },
                  child: const Text("Yes"),
                ),
              ),
            ],
          ),
        ],
        content: Container(
          padding: const EdgeInsets.fromLTRB(21, 16, 21, 10),
          height: 400,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.imagesDuck1,
                  height: 40,
                ),
                3.height,
                FittedBox(
                    child: AppText(
                      text: subtitle??'      ',
                      maxLines: 2,
                      fontSize: 20,
                      color: context.colorScheme.onSurface,
                    )),
                13.height,
                AppText(
                  text: text,
                  maxLines: 3,
                  fontSize: 16,
                  color: context.colorScheme.onSecondary,
                )
              ]),
        )

    );
  }
}