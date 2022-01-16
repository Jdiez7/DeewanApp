class Vocab {
  final int id;
  final String englishMain;
  final String arabicMain;
  final String exampleSentence;

  const Vocab({
    required this.id,
    required this.arabicMain,
    required this.englishMain,
    required this.exampleSentence,
  });

  factory Vocab.fromJson(Map<String, dynamic> json) => Vocab(
    id: json['id'],
    arabicMain: json['author'],
    englishMain: json['title'],
    exampleSentence: json['urlImage'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': englishMain,
    'author': arabicMain,
    'urlImage': exampleSentence,
  };
}

final List<int> hello = [1,2,3,4,];