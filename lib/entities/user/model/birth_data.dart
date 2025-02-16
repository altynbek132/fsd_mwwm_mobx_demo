import 'package:freezed_annotation/freezed_annotation.dart';

part 'birth_data.freezed.dart';
part 'birth_data.g.dart';

/// SIGN UP
@freezed
class BirthData with _$BirthData {
  factory BirthData({
    required String day,
    required String month,
    required String year,
  }) = _BirthData;

  factory BirthData.fromJson(Map<String, dynamic> json) => _$BirthDataFromJson(json);

  @override
  // ignore: unnecessary_overrides
  Map<String, dynamic> toJson() => super.toJson();
}
