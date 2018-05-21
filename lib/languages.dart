
const languages = const [
  const Language('Turkish', 'tr_TR'),
  const Language('English', 'en_US'),
  const Language('Ελληνοκύ', 'el_CY'),
  const Language('Pусский', 'ru_RU'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}