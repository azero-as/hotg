// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('FinishedWorkout:', () {
// First, define the Finders. We can use these to locate Widgets from the
// test suite. Note: the Strings provided to the `byValueKey` method must
// be the same as the Strings we used for the Keys.

    //Widget from frontpage
    final logInButton = find.byValueKey('LogIn');

    //Widgets from login
    final usernameTextField = find.byValueKey("loginUsername");
    final passwordTextField = find.byValueKey("loginPassword");
    final logInButton2 = find.byValueKey("LogIn2");

    //Widgets from dashboard
    final settingsButton = find.byValueKey("settingsButton");
    final signOutButton = find.byValueKey("signOutButton");

    final recommendedWorkout = find.byValueKey("recommendedWorkout");
    final startWorkout = find.byValueKey("startWorkoutButton");
    final finishWorkout = find.byValueKey("finishWorkoutButton");
    final noExercisesPopUp = find.byValueKey("NoExercisesPopUp");
    final outOfPopUp = find.byValueKey("crossOutPopUpNE");
    final backToStartWorkout = find.byValueKey("backToStartWorkout");
    final backToHome = find.byValueKey("backToHome");

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

    test('unFinished Workout PopUp', () async {
      //Log in
      await driver.tap(logInButton);
      await driver.tap(usernameTextField);
      await driver.enterText("test@example.com");
      await driver.tap(passwordTextField);
      await driver.enterText("test1234");
      await driver.tap(logInButton2);

      await driver.tap(recommendedWorkout);
      await driver.tap(startWorkout);
      await driver.tap(finishWorkout);

      expect(await driver.getText(noExercisesPopUp), "No exercises done");


      // Back to home page
      await driver.tap(outOfPopUp);
      await driver.tap(backToStartWorkout);
      await driver.tap(backToHome);

      //Logs out
      await driver.tap(settingsButton);
      await driver.tap(signOutButton);
    });

  });

  group('Log In:', () {
    // First, define the Finders. We can use these to locate Widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys.

      //Widget from frontpage
      final logInButton = find.byValueKey('LogIn');

      //Widgets from login
      final usernameTextField = find.byValueKey("loginUsername");
      final passwordTextField = find.byValueKey("loginPassword");
      final logInButton2 = find.byValueKey("LogIn2");
      final errormessage = find.byValueKey("LogInErrorMessage");
      final loginBackButton = find.byValueKey("loginBackButton");

      //Widgets from dashboard
      final settingsButton = find.byValueKey("settingsButton");
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
      await driver.tap(settingsButton);
      await driver.tap(signOutButton);
    });
  });

  group('Sign Up:', () {
// First, define the Finders. We can use these to locate Widgets from the
// test suite. Note: the Strings provided to the `byValueKey` method must
// be the same as the Strings we used for the Keys.

//Widget from frontpage
    final signUpButton = find.byValueKey('SignUp');

//Widgets from login
    final usernameTextField = find.byValueKey("signupEmail");
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

    test("Password badly formatted", () async {
      await driver.tap(signUpButton);
      await driver.tap(usernameTextField);
      await driver.enterText("testNOTAUSER@example.com");
      await driver.tap(passwordTextField);
      await driver.enterText("test");
      await driver.tap(passwordTextField2);
      await driver.enterText("test");
      await driver.tap(signUpButton2);
      expect(await driver.getText(errormessage), "The password must be 6 characters long or more.");

      await driver.tap(signupBackButton);
    });
  });

  group('Dashboard info:', () {
    // First, define the Finders. We can use these to locate Widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys.

    //Widget from frontpage
    final logInButton = find.byValueKey('LogIn');

    //Widgets from login
    final usernameTextField = find.byValueKey("loginUsername");
    final passwordTextField = find.byValueKey("loginPassword");
    final logInButton2 = find.byValueKey("LogIn2");

    //Widgets from dashboard
    final settingsButton = find.byValueKey("settingsButton");
    final signOutButton = find.byValueKey("signOutButton");

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();

      await driver.tap(logInButton);
      await driver.tap(usernameTextField);
      await driver.enterText("test@example.com");
      await driver.tap(passwordTextField);
      await driver.enterText("test1234");
      await driver.tap(logInButton2);
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      //Log out
      await driver.tap(settingsButton);
      await driver.tap(signOutButton);

      if (driver != null) {
        driver.close();
      }
    });

    final charName = find.byValueKey("charName");
    final userXp = find.byValueKey("xp");
    final levelClass = find.byValueKey("levelClass");

    //IT 1
    test("Correct character name is shown on the dashboard", () async {
      expect( await driver.getText(charName), "testusername");
    });

    //IT 2
    test("Correct amount of XP is shown on the dashboard.", () async {
      var xp = await driver.getText(userXp);
      
      expect(xp.substring(0,2), "43");
    });

    //IT 10
    test("Correct level is shown on the dashboard.", () async {
      var levelAndClass = await driver.getText(levelClass);
      var list = levelAndClass.split(' ');
      var level = list[1];

      expect(level, "2");
    });

    //IT 20
    test("Correct class is shown on the dashboard.", () async {
      var levelAndClass = await driver.getText(levelClass);
      var list = levelAndClass.split(' ');
      var className = list[2];

      expect(className, "Ranger");
    });
  });

  group('Finish workout:', () {

    //Widget from frontpage
    final logInButton = find.byValueKey('LogIn');

    //Widgets from login
    final usernameTextField = find.byValueKey("loginUsername");
    final passwordTextField = find.byValueKey("loginPassword");
    final logInButton2 = find.byValueKey("LogIn2");

    //Widgets from dashboard
    final settingsButton = find.byValueKey("settingsButton");
    final signOutButton = find.byValueKey("signOutButton");

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();

      await driver.tap(logInButton);
      await driver.tap(usernameTextField);
      await driver.enterText("test@example.com");
      await driver.tap(passwordTextField);
      await driver.enterText("test1234");
      await driver.tap(logInButton2);
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      //Log out
      await driver.tap(settingsButton);
      await driver.tap(signOutButton);

      //TODO: Reset database to inital state for test user
      //https://us-central1-heroes-6fe69.cloudfunctions.net/resetTestUser
      print("Please go to this url to reset the database: https://us-central1-heroes-6fe69.cloudfunctions.net/resetTestUser");

      if (driver != null) {
        driver.close();
      }
    });

    //used for complete a workout from the workouts tab
    final navigationBar = find.byValueKey("navigationBar");
    final greenRangerWorkout = find.byValueKey("Green Ranger Workout");
    final startWorkout = find.byValueKey("startWorkout");
    final warmUp = find.byValueKey("warmUp");
    final exercise0 = find.byValueKey("exercise0");
    final exercise1 = find.byValueKey("exercise1");
    final exercise2 = find.byValueKey("exercise2");
    final exercise3 = find.byValueKey("exercise3");
    final finishButton = find.byValueKey("finishButton");
    final summaryExit = find.byValueKey("summaryExit");

    //IT 15
    test("XP should increase with the equivalent value after finishing a workout", () async {
      await driver.tap(navigationBar);
      await driver.tap(greenRangerWorkout);
      await driver.tap(startWorkout);
      await driver.tap(warmUp);
      await driver.tap(exercise0);
      await driver.tap(exercise1);
      await driver.tap(exercise2);
      await driver.tap(exercise3);
      await driver.tap(finishButton);
      await driver.tap(summaryExit);
      await Future.delayed(const Duration(seconds: 5));

      var userXp = await find.byValueKey("xp");
      var xp = await driver.getText(userXp);

      expect(xp.substring(0,3), "133");
    });

    //IT 19
    test("Level indicator is incremented by 1 when reaching a new level", () async {
      await driver.tap(navigationBar);
      await driver.tap(greenRangerWorkout);
      await driver.tap(startWorkout);
      await driver.tap(warmUp);
      await driver.tap(exercise0);
      await driver.tap(exercise1);
      await driver.tap(exercise2);
      await driver.tap(exercise3);
      await driver.tap(finishButton);
      await driver.tap(summaryExit);
      await Future.delayed(const Duration(seconds: 5));

      var levelClass = await find.byValueKey("levelClass");
      var levelAndClass = await driver.getText(levelClass);
      var list = levelAndClass.split(' ');
      var level = list[1];

      expect(level, "3");
    });
  });

}