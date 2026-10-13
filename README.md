# Devotion

A calm daily devotional + Bible reading app, built in Flutter from the 15-screen HTML mockup. Edge-to-edge, light theme, Plus Jakarta Sans, and the mockup's own SVG icons and illustrations.

## Requirements
- Flutter 3.24+ (Dart 3.4+)
- Internet for chapter text (falls back to a tiny offline sample)

## Run it
```
flutter create --project-name devotion_app --org com.example .
flutter pub get
flutter run -d chrome      # quickest preview
flutter run                # device / emulator
```
`flutter create .` only generates the platform folders (android/ios/web…); it leaves `lib/` alone.
For release Android builds add `<uses-permission android:name="android.permission.INTERNET"/>` to `android/app/src/main/AndroidManifest.xml`.

## Font
`assets/fonts/PlusJakartaSans.ttf` (variable, open-source) is bundled. To use your own file, overwrite it with the same name — or change the path in `pubspec.yaml` (registered for weights 200–800).

## Flows (all wired)
Splash → Onboarding (3 pages) → Home/Bible/Plans/You tabs.
- **Home**: today's devotional → reading → mark complete → completed screen (add a reflection) → back home. Plan card → progress. Target icon on the hero → Devotionals hub (Today / All, weekly dots).
- **Bible**: search books or refs ("John 3:16"), chapter picker, reader with verse options (bookmark, note, share/copy, highlight), toolbar (bookmark, highlight, copy reference, Aa text size, focus mode), chapter dropdown, copy chapter.
- **Bookmarks** (You → Bookmarks): Verses and Passages; tap to jump back into the reader.
- **Plans**: list (All / My Plans) → detail → Start Plan → progress ring. "Continue" opens the day's passage; a day completes automatically once you've read to its last verse.
- **You**: edit name, reading history, bookmarks, completed devotionals, reminders (time picker + day toggles), settings (text size, reset demo data, sign out).
- State persists locally (shared_preferences).

## Mocked vs real
- Mocked: devotionals (`lib/data/mock/devotionals.dart`), plans (`plans.dart`), seeded bookmarks/history/plan progress/completions, sign-in ("I already have an account" just enters the app). Services in `lib/services/` are the seam for a real backend.
- Real: chapter text from bible-api.com (World English Bible), local persistence, all navigation and state.
- Reminders are stored but **do not fire notifications yet** (needs `flutter_local_notifications` + platform setup).
- Share = copy to clipboard (no share sheet plugin, to keep the build dependency-light).

## Structure
```
assets/{fonts,images}   lib/{theme,models,data,services,state,navigation,widgets,screens,utils}
```

## Known gaps / assumptions (not in the mockup)
- Onboarding pages 2–3 copy, chapter-picker sheet, note sheet, name/reflection sheets, Reading history, Completed devotionals and Settings screens were added so every control has a destination; they reuse the mockup's styles.
- Devotional reading has a "Mark as complete" button at the end (the mockup shows none, but screen 10 needs a trigger).
- Weekend reminder days render in the lighter green from the mockup's Saturday dot.
- Bible text is WEB, not NIV, so wording differs slightly from the mockup. Swap `BibleService` for another source if you hold a licence.
- Not compiled in the sandbox (no Flutter SDK available) — run `flutter analyze` first.
