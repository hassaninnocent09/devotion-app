import '../../models/bible.dart';

/// Tiny offline sample so the reader still works with no connection.
class BibleOffline {
  BibleOffline._();

  static final Map<String, List<Verse>> _chapters = {
    'Genesis 1': const [
      Verse(1, 'In the beginning God created the heavens and the earth.'),
      Verse(2, 'Now the earth was formless and empty, darkness was over the surface of the deep, and the Spirit of God was hovering over the waters.'),
      Verse(3, 'And God said, “Let there be light,” and there was light.'),
    ],
    'Psalms 23': const [
      Verse(1, 'The Lord is my shepherd; I shall not want.'),
      Verse(2, 'He maketh me to lie down in green pastures: he leadeth me beside the still waters.'),
      Verse(3, 'He restoreth my soul: he leadeth me in the paths of righteousness for his name’s sake.'),
      Verse(4, 'Yea, though I walk through the valley of the shadow of death, I will fear no evil: for thou art with me; thy rod and thy staff they comfort me.'),
      Verse(5, 'Thou preparest a table before me in the presence of mine enemies: thou anointest my head with oil; my cup runneth over.'),
      Verse(6, 'Surely goodness and mercy shall follow me all the days of my life: and I will dwell in the house of the Lord for ever.'),
    ],
  };

  static List<Verse>? chapter(String book, int chapter) => _chapters['$book $chapter'];
}
