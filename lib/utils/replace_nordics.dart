/// Replaces all the nordics from [text] with 'a' or 'o' and makes it lowercase.
///
/// {@category Utils}
String replaceNordics({required String text}) {
  final regularA = RegExp('[äåáàâãåæ]', caseSensitive: false);
  final regularO = RegExp('[öøóòôõ]', caseSensitive: false);
  return text.replaceAll(regularA, 'a').replaceAll(regularO, 'o').toLowerCase();
}
