String replaceNordics({required String text}) {
  final regularA = RegExp('[äåáàâãåæ]', caseSensitive: false);
  final regularO = RegExp('[öøóòôõ]', caseSensitive: false);
  return text.replaceAll(regularA, 'a').replaceAll(regularO, 'o');
}
