import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import 'app_icon.dart';
import 'cards.dart';
import 'motion.dart';
import 'primary_button.dart';

Future<T?> _showSheet<T>(BuildContext context, WidgetBuilder builder) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.dim,
    elevation: 0,
    builder: builder,
  );
}

class _SheetShell extends StatelessWidget {
  const _SheetShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final kb = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: kb),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(22, 10, 22, 16 + Insets.bottom(context)),
        decoration: const BoxDecoration(
          color: AppColors.sheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

String verseShareText(String book, int chapter, Verse v) => '“${v.text}”\n— $book $chapter:${v.number} (KJV)';

/// Verse options sheet.
Future<void> showVerseOptions(
  BuildContext context, {
  required Book book,
  required int chapter,
  required Verse verse,
}) {
  final state = context.read<AppState>();
  final messenger = ScaffoldMessenger.of(context);
  final host = context;
  final saved = state.savedVerse(book.name, chapter, verse.number);

  void toast(String m) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(m), duration: const Duration(milliseconds: 1800)));
  }

  return _showSheet<void>(context, (ctx) {
    Widget item(String icon, String label, VoidCallback onTap, {bool on = false}) {
      return Pressable(
        scale: 0.98,
        onTap: () {
          Navigator.of(ctx).pop();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              IconTile(icon, size: 40, filled: on),
              const SizedBox(width: 16),
              Expanded(child: Text(label, style: AppText.t(14, w: FontWeight.w500))),
              const AppIcon('right', size: 20, color: AppColors.faint),
            ],
          ),
        ),
      );
    }

    return _SheetShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${book.name} $chapter:${verse.number}', style: AppText.t(15, w: FontWeight.w600)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(16)),
            child: Text(verse.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppText.serif(14, color: AppColors.inkDim, lh: 22)),
          ),
          const SizedBox(height: 10),
          item('bookmark', saved?.bookmarked == true ? 'Remove bookmark' : 'Add bookmark', () {
            final on = state.toggleBookmark(book, chapter, verse);
            toast(on ? 'Bookmark added' : 'Bookmark removed');
          }, on: saved?.bookmarked == true),
          item('pen', saved?.highlighted == true ? 'Remove highlight' : 'Highlight', () {
            final on = state.toggleHighlight(book, chapter, verse);
            toast(on ? 'Verse highlighted' : 'Highlight removed');
          }, on: saved?.highlighted == true),
          item('note', (saved?.note ?? '').isNotEmpty ? 'Edit note' : 'Add note', () {
            if (host.mounted) showNoteSheet(host, book: book, chapter: chapter, verse: verse);
          }),
          item('share', 'Share verse', () {
            Clipboard.setData(ClipboardData(text: verseShareText(book.name, chapter, verse)));
            toast('Verse copied, ready to share');
          }),
          item('copy', 'Copy verse', () {
            Clipboard.setData(ClipboardData(text: verseShareText(book.name, chapter, verse)));
            toast('Verse copied');
          }),
          const SizedBox(height: 8),
          Pressable(
            onTap: () => Navigator.of(ctx).pop(),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: Center(child: Text('Cancel', style: AppText.t(14, w: FontWeight.w500, color: AppColors.muted))),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _field(TextEditingController c, String hint, int minLines, int maxLines) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(16)),
    child: TextField(
      controller: c,
      autofocus: true,
      minLines: minLines,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      style: AppText.t(14, color: AppColors.ink, lh: 22),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: AppText.t(14, color: AppColors.muted, lh: 22),
      ),
    ),
  );
}

/// Add / edit a note on a verse.
Future<void> showNoteSheet(
  BuildContext context, {
  required Book book,
  required int chapter,
  required Verse verse,
}) {
  final state = context.read<AppState>();
  final existing = state.savedVerse(book.name, chapter, verse.number)?.note ?? '';
  final controller = TextEditingController(text: existing);

  return _showSheet<void>(context, (ctx) {
    return _SheetShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(existing.isEmpty ? 'Add note' : 'Edit note', style: AppText.t(17, w: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('${book.name} $chapter:${verse.number}', style: AppText.t(13, color: AppColors.muted)),
          const SizedBox(height: 16),
          _field(controller, 'Write a note…', 3, 6),
          const SizedBox(height: 16),
          PrimaryButton('Save', onTap: () {
            state.setNote(book, chapter, verse, controller.text);
            Navigator.of(ctx).pop();
          }),
        ],
      ),
    );
  });
}

/// Chapter grid for a book. Returns the chosen chapter.
Future<int?> showChapterPicker(BuildContext context, Book book, {int? current}) {
  return _showSheet<int>(context, (ctx) {
    final maxH = MediaQuery.sizeOf(ctx).height * 0.65;
    return _SheetShell(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.name, style: AppText.serif(22, w: FontWeight.w500)),
            const SizedBox(height: 2),
            Text('${book.chapters} chapters', style: AppText.t(13, color: AppColors.muted)),
            const SizedBox(height: 16),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: book.chapters,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (_, i) {
                  final n = i + 1;
                  final on = n == current;
                  return Pressable(
                    scale: 0.92,
                    onTap: () => Navigator.of(ctx).pop(n),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: on ? AppColors.green : AppColors.field,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text('$n',
                          style: AppText.t(14,
                              w: on ? FontWeight.w600 : FontWeight.w500,
                              color: on ? Colors.white : AppColors.ink)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  });
}

/// Single-field text sheet (reflection, name).
Future<String?> showTextSheet(
  BuildContext context, {
  required String title,
  required String hint,
  String initial = '',
  int minLines = 1,
  int maxLines = 1,
}) {
  final controller = TextEditingController(text: initial);
  return _showSheet<String>(context, (ctx) {
    return _SheetShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.t(17, w: FontWeight.w600)),
          const SizedBox(height: 16),
          _field(controller, hint, minLines, maxLines),
          const SizedBox(height: 16),
          PrimaryButton('Save', onTap: () => Navigator.of(ctx).pop(controller.text)),
        ],
      ),
    );
  });
}

/// Confirm dialog styled to the theme.
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final res = await showDialog<bool>(
    context: context,
    barrierColor: AppColors.dim,
    builder: (ctx) => Dialog(
      backgroundColor: AppColors.sheet,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.t(17, w: FontWeight.w600)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(message, style: AppText.t(14, color: AppColors.muted, lh: 21)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('Cancel', style: AppText.t(14, w: FontWeight.w500, color: AppColors.muted)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(confirmLabel, style: AppText.t(14, w: FontWeight.w600, color: AppColors.green)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return res ?? false;
}
