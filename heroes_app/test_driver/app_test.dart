// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Log In', () {
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
      final loginBackButton = find.byValueKey("loginBackButton");

      //Widgets from dashboard
      final signOutButton = find.byValueKey("signOutButton");

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

      //Go back to frontpage
      await driver.tap(loginBackButton);
    });

    test("Login succeeded", () async {
      await driver.tap(logInButton);
      await driver.tap(usernameTextField);
      await driver.enterText("test@example.com");
      await driver.tap(passwordTextField);
      await driver.enterText("test1234");
      await driver.tap(logInButton2);

      //Sign up (back to frontpage)
      await driver.tap(signOutButton);
    });
  });

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
    final signupBackButton = find.byValueKey("signupBackButton");

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
      await driver.tap(passwordTextField2);
      await driver.enterText("wrongPassword2");
      await driver.tap(signUpButton2);
      expect(await driver.getText(errormessage), "Passwords are different");

      await driver.tap(signupBackButton);
    });

    test("Badly formatted email", () async {
      await driver.tap(signUpButton);
      await driver.tap(usernameTextField);
      await driver.enterText("badlyformattedemail");
      await driver.tap(passwordTextField);
      await driver.enterText("wrongPassword2");
      await driver.tap(passwordTextField2);
      await driver.enterText("wrongPassword2");
      await driver.tap(signUpButton2);
      expect(await driver.getText(errormessage), "The email address is badly formatted.");

      await driver.tap(signupBackButton);
    });

    test("User already exists", () async {
      await driver.tap(signUpButton);
      await driver.tap(usernameTextField);
      await driver.enterText("test@example.com");
      await driver.tap(passwordTextField);
      await driver.enterText("wrongPassword2");
      await driver.tap(passwordTextField2);
      await driver.enterText("wrongPassword2");
      await driver.tap(signUpButton2);
      expect(await driver.getText(errormessage), "The email address is already in use by another account.");

      await driver.tap(signupBackButton);
    });
  });
}