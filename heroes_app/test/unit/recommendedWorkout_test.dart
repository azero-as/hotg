import '../../lib/logic/recommendedWorkoutLogic.dart';
import 'package:test/test.dart';

void main() {
  test('Barbarian should be converted to Paladin', () {
    var result = convertClassName("Barbarian");
    expect(result, 'Paladin');
  });

  test('Paladin should return Paladin', () {
    var result = convertClassName("Paladin");
    expect(result, 'Paladin');
  });

  test('Monk should be converted to Ranger', () {
    var result = convertClassName("Monk");
    expect(result, 'Ranger');
  });

  test('Empty string should be converted to Ranger', () {
    var result = convertClassName("");
    expect(result, 'Ranger');
  });

  test('Random string should be converted to Ranger', () {
    var result = convertClassName("nameWhichIsNotAClass");
    expect(result, 'Ranger');
  });
}
