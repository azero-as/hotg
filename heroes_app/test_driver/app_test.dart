// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Heroes App', () {
    // First, define the Finders. We can use these to locate Widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys.

      //Widget from frontpage
      final logInButton = find.byValueKey('LogIn');

      //Widgets from login
      final usernameTextField = find.byValueKey("loginUsername");;
      final passwordTextField = find.byValueKey("loginPassword");
      final logInButton2 = find.byValueKey("LogIn2");
      final errormessage = find.byValueKey("LogInErrorMessage");

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Wrong password for login', () async {
      await driver.tap(logInButton);
      await driver.tap(usernameTextField);
      await driver.enterText("test@example.com");
      await driver.tap(passwordTextField);
      await driver.enterText("wrongPassword");//The correct password is test1234
      await driver.tap(logInButton2);
      expect(await driver.getText(errormessage), "Wrong email or password");
    });
  });
}