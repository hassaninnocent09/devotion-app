import 'package:flutter/material.dart';
import '../data/bible_books.dart';
import '../models/models.dart';
import '../services/devotional_service.dart';
import '../services/plan_service.dart';
import '../services/storage_service.dart';
import '../utils/format.dart';

class AppState extends ChangeNotifier {
  AppState._(this._storage, this.series, this.plans);

  static Future<AppState> create() async {
    final storage = await StorageService.open();
    final series = await DevotionalService().load();
    final plans = await PlanService().all();
    final s = AppState._(storage, series, plans);
    s._restore(storage.read());
    return s;
  }

  final StorageService _storage;
  final DevotionalSeries series;
  List<Devotional> get devotionals => series.items;
  final List<ReadingPlan> plans;

  // ---- session / profile ----
  bool onboarded = false;
  String name = 'Daniel';
  int tab = 0;
  int textSize = 1; // 0 small, 1 medium, 2 large

  // ---- devotionals ----
  final List<Completion> completions = [];
  final Map<String, String> reflections = {}; // dateKey -> text

  // ---- bible ----
  final Map<String, SavedVerse> verses = {}; // ref -> record
  final List<SavedPassage> passages = [];
  final List<HistoryEntry> history = [];

  // ---- plans ----
  final List<String> startedPlans = [];
  String? activePlanId;
  final Map<String, Set<int>> planDays = {};

  // ---- reminders ----
  ReminderSettings reminders = ReminderSettings.defaults();

  // ===================================================================
  // Persistence
  // ===================================================================
  void _save() {
    notifyListeners();
    _storage.write(_toJson());
  }

  Map<String, dynamic> _toJson() => {
        'onboarded': onboarded,
        'name': name,
        'textSize': textSize,
        'completions': completions.map((c) => c.toJson()).toList(),
        'reflections': reflections,
        'verses': verses.values.map((v) => v.toJson()).toList(),
        'passages': passages.map((p) => p.toJson()).toList(),
        'history': history.map((h) => h.toJson()).toList(),
        'started': startedPlans,
        'active': activePlanId,
        'planDays': planDays.map((k, v) => MapEntry(k, v.toList())),
        'reminders': reminders.toJson(),
      };

  void _restore(Map<String, dynamic>? j) {
    if (j == null) {
      _seed();
      return;
    }
    try {
      onboarded = j['onboarded'] as bool? ?? false;
      name = j['name'] as String? ?? 'Daniel';
      textSize = (j['textSize'] as int? ?? 1).clamp(0, 2).toInt();
      completions
        ..clear()
        ..addAll((j['completions'] as List).map((e) => Completion.fromJson(e as Map<String, dynamic>)));
      reflections
        ..clear()
        ..addAll((j['reflections'] as Map).map((k, v) => MapEntry(k as String, v as String)));
      verses.clear();
      for (final e in (j['verses'] as List)) {
        final v = SavedVerse.fromJson(e as Map<String, dynamic>);
        verses[v.ref] = v;
      }
      passages
        ..clear()
        ..addAll((j['passages'] as List).map((e) => SavedPassage.fromJson(e as Map<String, dynamic>)));
      history
        ..clear()
        ..addAll((j['history'] as List).map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>)));
      startedPlans
        ..clear()
        ..addAll((j['started'] as List).map((e) => e as String));
      activePlanId = j['active'] as String?;
      planDays
        ..clear()
        ..addAll((j['planDays'] as Map).map(
          (k, v) => MapEntry(k as String, (v as List).map((e) => e as int).toSet()),
        ));
      reminders = ReminderSettings.fromJson(j['reminders'] as Map<String, dynamic>);
    } catch (_) {
      _seed();
    }
  }

  /// Believable starting data so every screen has something real to show.
  void _seed() {
    final now = DateTime.now();
    final keepOnboarded = onboarded;
    onboarded = keepOnboarded;
    name = 'Daniel';
    textSize = 1;
    completions.clear();
    reflections.clear();
    verses.clear();
    passages.clear();
    history.clear();
    startedPlans.clear();
    planDays.clear();
    reminders = ReminderSettings.defaults();

    void addVerse(String book, int ch, int v, String text, int daysAgo, {bool bookmark = true}) {
      final rec = SavedVerse(
        book: book,
        chapter: ch,
        verse: v,
        text: text,
        addedAt: now.subtract(Duration(days: daysAgo)),
        bookmarked: bookmark,
        highlighted: !bookmark,
      );
      verses[rec.ref] = rec;
    }

    addVerse('Psalms', 23, 1, 'The Lord is my shepherd; I shall not want.', 0);
    addVerse('Philippians', 4, 13, 'I can do all this through him who gives me strength.', 2, bookmark: false);
    addVerse('Jeremiah', 29, 11, 'For I know the plans I have for you...', 4);

    passages.add(SavedPassage(
      ref: 'Psalm 23:1–3',
      text: 'The Lord is my shepherd; I shall not want. He maketh me to lie down in green pastures...',
      addedAt: now.subtract(const Duration(days: 3)),
    ));

    history
      ..add(HistoryEntry('John', 3, now.subtract(const Duration(hours: 20))))
      ..add(HistoryEntry('Psalms', 23, now.subtract(const Duration(days: 1, hours: 2))))
      ..add(HistoryEntry('Genesis', 1, now.subtract(const Duration(days: 2))));

    startedPlans.add('john');
    activePlanId = 'john';
    planDays['john'] = {1, 2, 3, 4};
  }

  // ===================================================================
  // Session
  // ===================================================================
  void completeOnboarding() {
    onboarded = true;
    _save();
  }

  void signOut() {
    onboarded = false;
    tab = 0;
    _save();
  }

  void resetDemoData() {
    _seed();
    tab = 0;
    _save();
  }

  void setTab(int i) {
    if (tab == i) return;
    tab = i;
    notifyListeners();
  }

  void setName(String v) {
    final t = v.trim();
    if (t.isEmpty) return;
    name = t;
    _save();
  }

  void setTextSize(int i) {
    textSize = i.clamp(0, 2).toInt();
    _save();
  }

  // ===================================================================
  // Devotionals
  // ===================================================================
  /// Today's devotional: the one finished today (so the Completed state shows),
  /// otherwise the next unfinished day in the series.
  Devotional get todayDevotional {
    final key = _today;
    for (final c in completions) {
      if (c.dateKey == key) {
        final d = devotionalById(c.devotionalId);
        if (d != null) return d;
      }
    }
    for (final d in devotionals) {
      if (!isDoneEver(d)) return d;
    }
    return devotionals.first;
  }

  int get completedCount => devotionals.where(isDoneEver).length;

  /// Consecutive days (ending today or yesterday) with a completed devotional.
  int get streak {
    var day = DateTime.now();
    if (!dayHasCompletion(day)) day = day.subtract(const Duration(days: 1));
    var n = 0;
    while (dayHasCompletion(day)) {
      n++;
      day = day.subtract(const Duration(days: 1));
    }
    return n;
  }

  String get _today => dateKey(DateTime.now());

  bool isDoneToday(Devotional d) =>
      completions.any((c) => c.devotionalId == d.id && c.dateKey == _today);

  bool isDoneEver(Devotional d) => completions.any((c) => c.devotionalId == d.id);

  bool dayHasCompletion(DateTime d) {
    final k = dateKey(d);
    return completions.any((c) => c.dateKey == k);
  }

  /// Newest first.
  List<Completion> get completedDevotionals {
    final list = [...completions];
    list.sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return list;
  }

  Devotional? devotionalById(String id) {
    for (final d in devotionals) {
      if (d.id == id) return d;
    }
    return null;
  }

  void completeDevotional(Devotional d) {
    if (!isDoneToday(d)) {
      completions.add(Completion(d.id, _today));
      _save();
    }
  }

  String? get reflectionToday => reflections[_today];

  void setReflection(String text) {
    final t = text.trim();
    if (t.isEmpty) {
      reflections.remove(_today);
    } else {
      reflections[_today] = t;
    }
    _save();
  }

  // ===================================================================
  // Bible: verses, passages, history
  // ===================================================================
  SavedVerse? savedVerse(String book, int chapter, int verse) => verses['$book $chapter:$verse'];

  SavedVerse _record(Book book, int chapter, Verse v) {
    final ref = '${book.name} $chapter:${v.number}';
    return verses.putIfAbsent(
      ref,
      () => SavedVerse(
        book: book.name,
        chapter: chapter,
        verse: v.number,
        text: v.text,
        addedAt: DateTime.now(),
      ),
    );
  }

  void _prune(SavedVerse r) {
    if (r.isEmpty) verses.remove(r.ref);
  }

  bool toggleBookmark(Book book, int chapter, Verse v) {
    final r = _record(book, chapter, v);
    r.bookmarked = !r.bookmarked;
    final now = r.bookmarked;
    _prune(r);
    _save();
    return now;
  }

  bool toggleHighlight(Book book, int chapter, Verse v) {
    final r = _record(book, chapter, v);
    r.highlighted = !r.highlighted;
    final now = r.highlighted;
    _prune(r);
    _save();
    return now;
  }

  void setNote(Book book, int chapter, Verse v, String text) {
    final r = _record(book, chapter, v);
    final t = text.trim();
    r.note = t.isEmpty ? null : t;
    _prune(r);
    _save();
  }

  /// Saved verses shown on the Bookmarks screen, newest first.
  List<SavedVerse> get savedVerses {
    final list = verses.values.where((v) => !v.isEmpty).toList();
    list.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return list;
  }

  bool isPassageSaved(String ref) => passages.any((p) => p.ref == ref);

  bool togglePassage(Devotional d) {
    final i = passages.indexWhere((p) => p.ref == d.reference);
    if (i >= 0) {
      passages.removeAt(i);
      _save();
      return false;
    }
    passages.insert(0, SavedPassage(ref: d.reference, text: d.keyVerse, addedAt: DateTime.now()));
    _save();
    return true;
  }

  void logVisit(Book book, int chapter) {
    if (history.isNotEmpty && history.first.book == book.name && history.first.chapter == chapter) {
      return;
    }
    history.removeWhere((h) => h.book == book.name && h.chapter == chapter);
    history.insert(0, HistoryEntry(book.name, chapter, DateTime.now()));
    if (history.length > 40) history.removeRange(40, history.length);
    _save();
  }

  Book? bookByName(String n) => BibleBooks.find(n);

  // ===================================================================
  // Reading plans
  // ===================================================================
  ReadingPlan? get activePlan {
    for (final p in plans) {
      if (p.id == activePlanId) return p;
    }
    return null;
  }

  bool isStarted(ReadingPlan p) => startedPlans.contains(p.id);
  List<ReadingPlan> get myPlans => plans.where(isStarted).toList();

  Set<int> doneDays(ReadingPlan p) => planDays[p.id] ?? <int>{};
  int doneCount(ReadingPlan p) => doneDays(p).length;
  double progress(ReadingPlan p) => p.totalDays == 0 ? 0 : doneCount(p) / p.totalDays;

  PlanDay? nextDay(ReadingPlan p) {
    final done = doneDays(p);
    for (final d in p.days) {
      if (!done.contains(d.day)) return d;
    }
    return null;
  }

  void startPlan(ReadingPlan p) {
    if (!startedPlans.contains(p.id)) startedPlans.add(p.id);
    planDays.putIfAbsent(p.id, () => <int>{});
    activePlanId = p.id;
    _save();
  }

  /// Returns true if the day was newly completed.
  bool completePlanDay(String planId, int day) {
    final set = planDays.putIfAbsent(planId, () => <int>{});
    if (!set.add(day)) return false;
    if (!startedPlans.contains(planId)) startedPlans.add(planId);
    _save();
    return true;
  }

  // ===================================================================
  // Reminders
  // ===================================================================
  void saveReminders(ReminderSettings r) {
    reminders = r;
    _save();
  }
}
