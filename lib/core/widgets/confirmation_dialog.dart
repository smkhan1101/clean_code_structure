import '../../imports.dart';

Future showConfirmationDialog({
  required String title,
  required String subtitle,
  required String actionText,
  required Function() onAccept,
}) {
  return showDialog(
    context: Get.context!,
    builder: (context) => ConfirmationDialog(
      title: title,
      subtitle: subtitle,
      actionText: actionText,
      onAccept: onAccept,
    ),
  );
}

class ConfirmationDialog extends StatelessWidget {
  final String title, subtitle, actionText;
  final Function() onAccept;
  const ConfirmationDialog({
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAccept,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),
            SizedBox(height: 16.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (actionText.toLowerCase() != 'ok')
                  Expanded(
                    child: PrimaryOutlineButton(
                      text: 'cancel'.tr,
                      onPressed: pop,
                      textColor: context.textTheme.bodyLarge!.color,
                    ),
                  ),
                if (actionText.toLowerCase() != 'ok') SizedBox(width: 16.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF5CBF60),
                          Color(0xFF4CAF50),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        onAccept();
                        pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        actionText,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
