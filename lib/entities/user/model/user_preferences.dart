import 'dart:convert';

import 'package:fsd_mwwm_mobx_demo/entities/user/model/birth_data.dart';
import 'package:fsd_mwwm_mobx_demo/shared/lib/rx_db.dart';

class UserPreferences {
  final RxDb db;

  UserPreferences({required this.db});

  final _selectedGenderKey = 'selectedGender';
  final _nicknameKey = 'nickname';
  final _birthDataKey = 'birthData';

  // Save selectedGender
  Future<void> saveSelectedGender(String gender) async {
    await db.write(key: _selectedGenderKey, value: gender);
  }

  // Load selectedGender
  Stream<String?> loadSelectedGender() {
    return db.read(key: _selectedGenderKey);
  }

  // Save nicknameForm value
  Future<void> saveNickname(String nickname) async {
    await db.write(key: _nicknameKey, value: nickname);
  }

  // Load nicknameForm value
  Stream<String?> loadNickname() {
    return db.read(key: _nicknameKey);
  }

  // Save birthForm as JSON string
  Future<void> saveBirthData(BirthData birthData) async {
    await db.write(key: _birthDataKey, value: jsonEncode(birthData.toJson()));
  }

  Stream<BirthData?> loadBirthData() {
    return db.read(key: _birthDataKey).map(
      (jsonString) {
        if (jsonString == null) {
          return null;
        }
        return BirthData.fromJson(jsonDecode(jsonString));
      },
    );
  }
}
