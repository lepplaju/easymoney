/// Class for holding user information used when composing the invoice
class Profile {
  /// Creates the profile with [id], [firstName], [lastName] and [iban]
  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.iban,
  });

  /// Creates a profile from map
  ///
  /// Takes a [map] containing fields: id, firstName, lastName and iban
  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        iban = map['iban'];

  final int id;
  final String firstName;
  final String lastName;
  final String iban;

  /// Returns the profile as a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'iban': iban,
    };
  }

  @override
  String toString() {
    return 'Profile{'
        'id: $id, '
        'firstName: $firstName, '
        'lastName: $lastName, '
        'iban: $iban'
        '}';
  }
}
