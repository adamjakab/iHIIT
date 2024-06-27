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

  // Initialize the controller
  public function initialize(WOI) {
    currentWorkout = new $.Workout(WOI);
    finish_workout_option = 0;
  }

  public function getInitialApplicationView() as [Ui.View, Ui.BehaviorDelegate] {
    return [new SelectWorkoutView(), new SelectWorkoutDelegate()];

    //TEMPORARY - SKIP workout selection
    //initialize(1)
    //beginCurrentWorkout();
    //return [new DoWorkoutView(), new DoWorkoutDelegate()];

    //TEMPORARY - TEST OmniMenu
    //return testOmniMenu();
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

  // @TODO: REMOVE ME!
  // public function testOmniMenu() {
  //   var choices = {
  //     0 => { "label" => "Choice #1", "callback" => null },
  //     1 => { "label" => "Choice #2", "callback" => null },
  //     2 => { "label" => "Choice #3", "callback" => null },
  //     3 => { "label" => "Choice #4", "callback" => null },
  //     4 => { "label" => "Choice #5", "callback" => null },
  //   };

  //   return [new OmniMenuView(choices, 0), new OmniMenuDelegate(null)];
  // }

  // Handle timing out after exit
  public function onExit() {
    Sys.exit();
  }
}
