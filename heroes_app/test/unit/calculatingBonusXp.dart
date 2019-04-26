import '../../lib/logic/calculateXp.dart';
import 'package:test/test.dart';

void main() {
  test('Correct BonusXP of 40', () {
    int result = calculateBonusXP(40);
    expect(result, 8);
  });

  test('Correct BonusXP when rounding up', () {
    int result = calculateBonusXP(14);
    expect(result, 3);
  });

  test('Correct BonusXP when rounding down', () {
    int result = calculateBonusXP(102);
    expect(result, 20);
  });

  test('Correct BonusXP when 0', () {
    int result = calculateBonusXP(0);
    expect(result, 0);
  });
}
