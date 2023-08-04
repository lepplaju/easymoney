import 'package:flutter/widgets.dart';

import '../domain/profile.dart';
import '../data/profile_repository.dart';

class ProviderProfiles with ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();
  final List<Profile> _profiles = [];

  List<Profile> get profiles {
    return _profiles;
  }

  Future<void> addProfile({
    required String firstName,
    required String lastName,
    required String iban,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    final profile = Profile(
      id: id,
      firstName: firstName,
      lastName: lastName,
      iban: iban,
    );

    await _profileRepository.addProfile(profile: profile);
    _profiles.add(profile);
    notifyListeners();
  }

  Future<void> getProfiles() async {
    final newProfiles = await _profileRepository.getProfiles();
    if (newProfiles.isEmpty) {
      return Future.error(Exception('At least one profile is required'));
    }

    _profiles.addAll(newProfiles);
    notifyListeners();
  }
}
