class Book {
  Book(this.name, this.chapters, {required this.oldTestament, String? api})
      : apiName = api ?? name;

  final String name;
  final int chapters;
  final bool oldTestament;

  /// Name sent to the chapter API.
  final String apiName;
}

class Verse {
  const Verse(this.number, this.text);
  final int number;
  final String text;
}
