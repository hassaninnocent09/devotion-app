import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import 'app_icon.dart';

/// Centered title with a back chevron (`.hd`).
class BackHeader extends StatelessWidget {
  const BackHeader(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(26, Insets.top(context) + 28, 26, 0),
      child: SizedBox(
        height: 28,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(title, style: AppText.t(14)),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).maybePop(),
                child: const Padding(
                  padding: EdgeInsets.only(left: 4, right: 24),
                  child: Center(child: AppIcon('left', size: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
