/// Class for holding user information used when composing the invoice
class Profile {
  final int id;
  final String profileName;
  final String firstName;
  final String lastName;
  final String iban;
  final String target;

  /// Creates the profile with [id], [profileName], [firstName], [lastName],
  /// [iban] and target.
  Profile({
    required this.id,
    required this.profileName,
    required this.firstName,
    required this.lastName,
    required this.iban,
    required this.target,
  });

  /// Creates a profile from map
  ///
  /// Takes a [map] containing fields: id, firstName, lastName and iban
  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        profileName = map['profileName'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        iban = map['iban'],
        target = map['target'];

  /// Returns the profile as a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileName': profileName,
      'firstName': firstName,
      'lastName': lastName,
      'iban': iban,
      'target': target,
    };
  }

  @override
  String toString() {
    return 'Profile{'
        'id: $id, '
        'profileName: $profileName, '
        'firstName: $firstName, '
        'lastName: $lastName, '
        'iban: $iban, '
        'target: $target'
        '}';
  }
}
