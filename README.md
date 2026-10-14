# Devotion

A calm daily devotional + Bible reading app in Flutter. Edge-to-edge, frosted headers, Material icons, Plus Jakarta Sans + Lora (weights 400/500/600 only).

## Run
```
flutter create --project-name devotion_app --org com.example .
flutter pub get
flutter run
```
No permissions needed: the Bible and devotionals are bundled and work fully offline.

## What's bundled
- **Bible**: full King James Version (public domain), `assets/data/kjv.json`, all 66 books.
- **Devotionals**: your "Walking With God" JSON, `assets/data/devotions.json` (10 days so far; add days 11-30 to the same file and the app picks them up).
- **Fonts**: `assets/fonts/PlusJakartaSans.ttf`, `Lora.ttf` (overwrite either to use your own).

## Design system
- Real device insets everywhere (no hard-coded top padding); large titles collapse into a blurred translucent header; frosted tab bar, reader toolbar and sticky CTAs.
- Motion: staggered fade/slide-in, press-scale on all taps, sliding segmented control, animated tab pill, progress bars/ring, elastic completion seal, tab cross-fade.
- Icons: Material rounded; back button is the arrow.

## Flows
Splash > onboarding > Home / Bible / Plans / You.
- Home: today's devotional (next unfinished day), series + plan progress.
- Devotional: scripture, devotion, reflect, pray, take action, mark complete, add reflection. "Read full passage" opens the verse in the Bible reader. Streak and week dots track completions.
- Bible: search books or refs ("John 3:16"), chapter picker, reader with verse options, notes, highlights, bookmarks, text size, focus mode, previous/next chapter.
- Plans: start, progress ring, passages open in the reader and complete when you reach the end.
- You: stats, history, bookmarks, completed devotionals, reminders, settings. State persists locally.

## Not yet real
- Reminders are saved but don't fire notifications (needs flutter_local_notifications + platform setup).
- Sign-in is mocked. Share copies to clipboard.
- Not compiled in the sandbox: run `flutter analyze` first.
