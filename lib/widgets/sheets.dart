import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/insets.dart';
import 'app_icon.dart';
import 'primary_button.dart';
import 'toast.dart';

Future<T?> _showSheet<T>(BuildContext context, WidgetBuilder builder) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
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
        padding: EdgeInsets.fromLTRB(22, 27, 22, 12 + Insets.bottom(context)),
        decoration: const BoxDecoration(
          color: AppColors.sheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(top: false, bottom: false, child: child),
      ),
    );
  }
}

String verseShareText(String book, int chapter, Verse v) =>
    '“${v.text}”\n— $book $chapter:${v.number}';

/// Screen 6 – Verse Options.
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
    Widget item(String icon, String label, VoidCallback onTap, {bool last = false}) {
      return InkWell(
        onTap: () {
          Navigator.of(ctx).pop();
          onTap();
        },
        child: Container(
          height: 61,
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            border: last ? null : const Border(bottom: BorderSide(color: AppColors.borderSoft)),
          ),
          child: Row(
            children: [
              AppIcon(icon, color: AppColors.inkDim),
              const SizedBox(width: 14),
              Text(label, style: AppText.t(13, w: FontWeight.w500, color: AppColors.inkDim)),
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
          Text('Verse Options', style: AppText.t(14, w: FontWeight.w700, lh: 18)),
          const SizedBox(height: 22),
          item('bookmark', saved?.bookmarked == true ? 'Remove Bookmark' : 'Add Bookmark', () {
            final on = state.toggleBookmark(book, chapter, verse);
            toast(on ? 'Bookmark added' : 'Bookmark removed');
          }),
          item('note', (saved?.note ?? '').isNotEmpty ? 'Edit Note' : 'Add Note', () {
            if (host.mounted) showNoteSheet(host, book: book, chapter: chapter, verse: verse);
          }),
          item('share', 'Share Verse', () {
            Clipboard.setData(ClipboardData(text: verseShareText(book.name, chapter, verse)));
            toast('Verse copied, ready to share');
          }),
          item('copy', 'Copy Verse', () {
            Clipboard.setData(ClipboardData(text: verseShareText(book.name, chapter, verse)));
            toast('Verse copied');
          }),
          item('pen', saved?.highlighted == true ? 'Remove Highlight' : 'Highlight', () {
            final on = state.toggleHighlight(book, chapter, verse);
            toast(on ? 'Verse highlighted' : 'Highlight removed');
          }, last: true),
          const SizedBox(height: 28),
          InkWell(
            onTap: () => Navigator.of(ctx).pop(),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Center(
                child: Text('Cancel', style: AppText.t(13, w: FontWeight.w500)),
              ),
            ),
          ),
        ],
      ),
    );
  });
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
          Text(existing.isEmpty ? 'Add Note' : 'Edit Note',
              style: AppText.t(14, w: FontWeight.w700, lh: 18)),
          const SizedBox(height: 8),
          Text('${book.name} $chapter:${verse.number}',
              style: AppText.t(13, color: AppColors.muted, lh: 18)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              style: AppText.t(14, color: AppColors.ink, lh: 22),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a note…',
                hintStyle: AppText.t(14, color: AppColors.muted, lh: 22),
              ),
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton('Save', height: 48, onTap: () {
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
    final maxH = MediaQuery.sizeOf(ctx).height * 0.7;
    return _SheetShell(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.name, style: AppText.t(14, w: FontWeight.w700, lh: 18)),
            const SizedBox(height: 4),
            Text('Select a chapter', style: AppText.t(13, color: AppColors.muted, lh: 18)),
            const SizedBox(height: 18),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: book.chapters,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (_, i) {
                  final n = i + 1;
                  final on = n == current;
                  return Material(
                    color: on ? AppColors.green : AppColors.field,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.of(ctx).pop(n),
                      child: Center(
                        child: Text('$n',
                            style: AppText.t(13,
                                w: on ? FontWeight.w700 : FontWeight.w500,
                                color: on ? Colors.white : AppColors.ink)),
                      ),
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
          Text(title, style: AppText.t(14, w: FontWeight.w700, lh: 18)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
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
          ),
          const SizedBox(height: 18),
          PrimaryButton('Save', height: 48, onTap: () => Navigator.of(ctx).pop(controller.text)),
        ],
      ),
    );
  });
}

/// Simple confirm dialog styled to the theme.
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.t(16, w: FontWeight.w700, lh: 22)),
            const SizedBox(height: 8),
            Text(message, style: AppText.t(13, color: AppColors.muted, lh: 20)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('Cancel', style: AppText.t(13, w: FontWeight.w600, color: AppColors.muted)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(confirmLabel,
                      style: AppText.t(13, w: FontWeight.w700, color: AppColors.green)),
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

// Re-exported for screens that only need the toast.
void toastOn(BuildContext c, String m) => showToast(c, m);
