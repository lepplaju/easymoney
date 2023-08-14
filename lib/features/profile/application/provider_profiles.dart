import 'package:flutter/widgets.dart';

import '../domain/profile.dart';
import '../data/profile_repository.dart';

/// Provider for managing user profiles
class ProviderProfiles with ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();
  final List<Profile> _profiles = [];
  Profile? _selectedProfile;

  /// Returns all of the profiles
  List<Profile> get profiles {
    return _profiles;
  }

  /// Returns the currently selected profile
  Profile? get selectedProfile {
    return _selectedProfile;
  }

  /// Selects the profile with [id] to be the selectedProfile
  void selectProfile({required int id}) {
    _selectedProfile = profiles.firstWhere((element) => element.id == id);
    notifyListeners();
  }

  /// Adds a profile
  ///
  /// Requires [profileName] which is used to identify the profile in the UI,
  /// [firstName], [lastName], [iban] and [target] to be used in the invoice.
  /// Target is the name of the house/organization of whom the receipts are.
  Future<void> addProfile({
    required String profileName,
    required String firstName,
    required String lastName,
    required String iban,
    required String target,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    final profile = Profile(
      id: id,
      profileName: profileName,
      firstName: firstName,
      lastName: lastName,
      iban: iban,
      target: target,
    );

    await _profileRepository.addProfile(profile: profile);
    _profiles.add(profile);
    notifyListeners();
  }

  /// Gets all the profiles from the database
  Future<void> getProfiles() async {
    _profiles.clear();
    final newProfiles = await _profileRepository.getProfiles();
    if (newProfiles.isEmpty) {
      return Future.error(Exception('At least one profile is required'));
    }
    _profiles.addAll(newProfiles);
    _selectedProfile = _profiles[0];
    notifyListeners();
  }
}
