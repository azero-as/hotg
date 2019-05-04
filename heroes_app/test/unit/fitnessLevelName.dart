import '../../lib/logic/fitnessLevelName.dart';
import 'package:test/test.dart';

void main() {
  test('Correct name for fitness Level 1', () {
    String result = convertFitnessLevelName(1);
    expect(result, "Beginner");
  });

  test('Correct name for fitness level 2', () {
    String result = convertFitnessLevelName(2);
    expect(result, "Intermediate");
  });

  test('Correct name for fitness level 3', () {
    String result = convertFitnessLevelName(3);
    expect(result, "Advanced");
  });
}
