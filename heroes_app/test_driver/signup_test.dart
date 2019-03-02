// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Sign Up', () {
// First, define the Finders. We can use these to locate Widgets from the
// test suite. Note: the Strings provided to the `byValueKey` method must
// be the same as the Strings we used for the Keys.

//Widget from frontpage
    final signUpButton = find.byValueKey('SignUp');

//Widgets from login
    final usernameTextField = find.byValueKey("signupEmail");;
    final passwordTextField = find.byValueKey("signupPassword");
    final passwordTextField2 = find.byValueKey("signupPassword2");
    final signUpButton2 = find.byValueKey("SignUp2");
    final errormessage = find.byValueKey("SignUpErrorMessage");

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

    test('Different passwords for SignUp', () async {
      await driver.tap(signUpButton);
      await driver.tap(usernameTextField);
      await driver.enterText("testNOTAUSER@example.com");
      await driver.tap(passwordTextField);
      await driver.enterText("wrongPassword");
      await driver.tap(passwordTextField);
      await driver.enterText("wrongPassword2");
      await driver.tap(signUpButton2);
      expect(await driver.getText(errormessage), "Passwords are different");
    });
  });
}
