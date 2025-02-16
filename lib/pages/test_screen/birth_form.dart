import 'package:reactive_forms/reactive_forms.dart';

class DayValidator extends Validator<dynamic> {
  const DayValidator() : super();

  static const errorCode = 'dayInvalid';

  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    final value = int.tryParse(control.value ?? '');
    if (value == null || value < 1 || value > 31) {
      return {errorCode: true};
    }
    return null;
  }
}

class MonthValidator extends Validator<dynamic> {
  const MonthValidator() : super();

  static const errorCode = 'monthInvalid';

  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    final value = int.tryParse(control.value ?? '');
    if (value == null || value < 1 || value > 12) {
      return {errorCode: true};
    }
    return null;
  }
}

class YearValidator extends Validator<dynamic> {
  const YearValidator() : super();

  static const errorCode = 'yearInvalid';

  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    final value = int.tryParse(control.value ?? '');
    if (value == null || value <= 0 || value > DateTime.now().year) {
      return {errorCode: true};
    }
    return null;
  }
}
