using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
import Toybox.Lang;

class iHIITController {
  private var saveTimer;

  protected var maxWorkoutTestCount = 10;
  protected var currentWorkout;

  public var finish_workout_option;
  public var discardConfirmationSelection = 0;

  public var omniMenuChoices as Dictionary = {};
  public var omniMenuSelectedIndex as Number = 0;

  public var test_view_index as Number = 0;
  private var test_view_count as Number = 0;

  // Initialize the controller
  public function initialize(WOI) {
    currentWorkout = new $.Workout(WOI);
    finish_workout_option = 0;
  }

  public function getInitialApplicationView() as [Ui.View, Ui.BehaviorDelegate] {
    return [new SelectWorkoutView(), new SelectWorkoutDelegate()];
  }

  /*
   * Start the selected workout
   */
  function beginCurrentWorkout() {
    if (!currentWorkout.isNotStarted()) {
      Sys.println("Controller: START REFUSED - Workout must be in stopped state to be started");
      return;
    }

    Sys.println("Controller: Starting Workout...");
    currentWorkout.startRecording();
    Ui.pushView(new DoWorkoutView(), new DoWorkoutDelegate(), Ui.SLIDE_UP);
  }

  /*
   * Stop the current Workout and show menu of options
   * Called by stop/back button presses and when Workout reaches last exercise and auto-terminates
   */
  function stopWorkout() {
    if (!currentWorkout.isRunning() && !currentWorkout.isTerminated()) {
      Sys.println("Controller: STOP REFUSED - Workout must be running or terminated");
      return;
    }

    Sys.println("Controller: Stopping workout...");
    if (currentWorkout.isRunning()) {
      currentWorkout.stopRecording();
    }

    // Configure choices
    var choices = ({}) as Dictionary;

    // Resume
    if (!currentWorkout.isTerminated()) {
      choices.put(choices.size(), {
        "label" => Ui.loadResource(Rez.Strings.finish_workout_prompt_resume),
        "callback" => method(:resumeWorkout),
      });
    }

    // Save & Exit
    choices.put(choices.size(), {
      "label" => Ui.loadResource(Rez.Strings.finish_workout_prompt_save_and_exit),
      "callback" => method(:saveWorkout),
    });

    // Discard and Exit
    choices.put(choices.size(), {
      "label" => Ui.loadResource(Rez.Strings.finish_workout_prompt_discard_and_exit),
      "callback" => method(:discardWorkout),
    });

    Ui.pushView(new OmniMenuView(choices, 0), new OmniMenuDelegate(method(:resumeWorkout)), Ui.SLIDE_UP);
  }

  /*
   * Resume workout
   */
  function resumeWorkout() {
    if (!currentWorkout.isPaused()) {
      Sys.println("Controller: RESUME REFUSED - Workout is already ended.");
      return;
    }

    Sys.println("Controller: Resuming workout.");
    currentWorkout.startRecording();
    Ui.popView(Ui.SLIDE_DOWN);
  }

  /*
   * Discard workout - Ask confirmation
   */
  function discardWorkout() {
    Sys.println("Controller: DISCARD");

    // Configure choices
    var choices = ({}) as Dictionary;

    choices.put(0, {
      "label" => Ui.loadResource(Rez.Strings.no),
      "callback" => method(:discardWorkout_Cancel),
    });

    choices.put(1, {
      "label" => Ui.loadResource(Rez.Strings.yes),
      "callback" => method(:discardWorkout_Confirm),
    });

    Ui.pushView(new OmniMenuView(choices, 0), new OmniMenuDelegate(method(:discardWorkout_Cancel)), Ui.SLIDE_UP);
  }

  // Discard Confirmation & go back to previouse selection
  function discardWorkout_Cancel() {
    Ui.popView(Ui.SLIDE_DOWN);
  }

  // Discard & go back to workout selection
  function discardWorkout_Confirm() {
    currentWorkout.discardRecording();
    initialize(currentWorkout.getWorkoutIndex());

    Ui.popView(Ui.SLIDE_DOWN);
    Ui.popView(Ui.SLIDE_DOWN);
    Ui.popView(Ui.SLIDE_DOWN);
  }

  /*
   * Save workout
   */
  public function saveWorkout() {
    Sys.println("Controller: Saving current workout...");
    Ui.pushView(new SaveWorkoutView(), new SaveWorkoutDelegate(), Ui.SLIDE_UP);

    currentWorkout.saveRecording();

    saveTimer = new Timer.Timer();
    saveTimer.start(method(:saveWorkoutDone), 5000, false);
  }

  public function saveWorkoutDone() as Void {
    if (saveTimer instanceof Timer.Timer) {
      saveTimer.stop();
      saveTimer = null;
    }
    initialize(currentWorkout.getWorkoutIndex());

    Ui.popView(Ui.SLIDE_DOWN);
    Ui.popView(Ui.SLIDE_DOWN);
    Ui.popView(Ui.SLIDE_DOWN);
  }

  //@todo: this method needs to be rewritten
  public function setNextWorkout() {
    var i;
    var workoutFound = false;
    var WOI = currentWorkout.getWorkoutIndex();

    for (i = WOI + 1; i <= maxWorkoutTestCount; i++) {
      if (WorkoutHelper.isSelectableWorkout(i)) {
        workoutFound = true;
        currentWorkout = new $.Workout(i);
        break;
      }
    }

    if (workoutFound == false) {
      for (i = 1; i <= WOI; i++) {
        if (WorkoutHelper.isSelectableWorkout(i)) {
          workoutFound = true;
          currentWorkout = new $.Workout(i);
          break;
        }
      }
    }

    Sys.println("WORKOUT(" + currentWorkout.getWorkoutIndex() + ") SET TO: " + currentWorkout.getTitle());

    return i;
  }

  //@todo: this method needs to be rewritten
  public function setPreviousWorkout() {
    var i;
    var workoutFound = false;
    var WOI = currentWorkout.getWorkoutIndex();

    for (i = WOI - 1; i > 0; i--) {
      if (WorkoutHelper.isSelectableWorkout(i)) {
        workoutFound = true;
        currentWorkout = new $.Workout(i);
        break;
      }
    }

    if (workoutFound == false) {
      for (i = maxWorkoutTestCount; i >= WOI; i--) {
        if (WorkoutHelper.isSelectableWorkout(i)) {
          workoutFound = true;
          currentWorkout = new $.Workout(i);
          break;
        }
      }
    }

    Sys.println("WORKOUT(" + currentWorkout.getWorkoutIndex() + ") SET TO: " + currentWorkout.getTitle());

    return i;
  }

  public function getCurrentWorkout() as $.Workout {
    return currentWorkout;
  }

  // ===================================================================================================TEST MODE
  // Init Test Mode - modification is needed in iHIIT:getInitialView to call this method
  (:debug)
  public function getInitialApplicationTestView() as [Ui.View, Ui.BehaviorDelegate] {
    return runTestMode();
  }

  /*
   * Init Test Mode
   */
  (:debug)
  public function runTestMode() {
    test_view_index = 1;
    test_view_count = 0;
    var views = getViewsToTest();
    var view = views[test_view_index];
    return [view, new TestModeDelegate()];
  }

  (:debug)
  private function getViewsToTest() as Array {
    // OmniView choices
    var choices =
      ({
        0 => { "label" => "Option #1", "callback" => null },
        1 => { "label" => "Option #2", "callback" => null },
        2 => { "label" => "Option #3", "callback" => null },
      }) as Dictionary;

    return [
      new TestModeView(),
      new SelectWorkoutView(),
      new DoWorkoutView(),
      new DoWorkoutView(),
      new DoWorkoutView(),
      new DoWorkoutView(),
      new SaveWorkoutView(),
      new OmniMenuView(choices, 0),
    ];
  }

  (:debug)
  public function testModeNextScreen() as Void {
    Sys.println("TESTMODE: next");
    var max = getViewsToTest().size();
    test_view_index = test_view_index + 1;
    if (test_view_index >= max) {
      test_view_index = 0;
    }
    testModeSetView();
  }

  (:debug)
  public function testModePreviousScreen() as Void {
    Sys.println("TESTMODE: prev");
    var max = getViewsToTest().size();
    test_view_index = test_view_index - 1;
    if (test_view_index < 0) {
      test_view_index = max - 1;
    }
    testModeSetView();
  }

  (:debug)
  public function testModeSetView() {
    Sys.println("TESTMODE: setting screen: " + test_view_index);

    // Special cases
    switch (test_view_index) {
      case 2:
        currentWorkout.setState(1); // Do workout - work
        currentWorkout.getCurrentExercise().setRestTime(false);
        break;
      case 3:
        currentWorkout.setState(1); // Do workout - rest
        currentWorkout.getCurrentExercise().setRestTime(true);
        break;
      case 4:
        currentWorkout.setState(5); // Pausing between repetitions
        break;
      case 5:
        currentWorkout.setState(3); // Workout terminated
        break;
    }

    // Remove the previous view
    if (test_view_count > 1) {
      Ui.popView(Ui.SLIDE_DOWN);
      test_view_count = test_view_count - 1;
    }

    var views = getViewsToTest();
    var view = views[test_view_index];
    var deleg = new TestModeDelegate();

    Ui.pushView(view, deleg, Ui.SLIDE_UP);
    test_view_count = test_view_count + 1;
  }
  // ===================================================================================================TEST MODE

  // Handle timing out after exit
  public function onExit() {
    Sys.exit();
  }
}
