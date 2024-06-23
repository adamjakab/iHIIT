using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class DoWorkoutView extends Ui.View {
  const LAYOUT_NONE = 0;
  const LAYOUT_REST = 1;
  const LAYOUT_WORK = 2;
  const LAYOUT_PAUSE = 3;
  const LAYOUT_DONE = 4;

  private var app;
  private var currentWorkout;
  private var currentLayout;

  // Strings
  private var str_total_time;
  private var str_rep_of_reps;
  private var str_exc_of_excs;

  // Layout elements
  private var labelHeartRateValue;
  private var labelReps;
  private var labelExcs;
  private var labelExerciseName;
  private var labelTimeRemaining;
  private var labelTimeTotal;

  public function initialize() {
    View.initialize();
    app = App.getApp();
    currentLayout = LAYOUT_NONE;

    // Strings
    str_total_time = Ui.loadResource(Rez.Strings.do_workout_done_total_time);
    str_rep_of_reps = Ui.loadResource(Rez.Strings.do_workout_rep_of_reps);
    str_exc_of_excs = Ui.loadResource(Rez.Strings.do_workout_exc_of_excs);

    Sys.println("DO-WORKOUT-VIEW - INIT");
  }

  //public function onLayout(dc) {}

  // Update the view - update is requested (Ui.requestUpdate()) by the workout model
  public function onUpdate(dc) {
    currentWorkout = app.getController().getCurrentWorkout();
    updateCurrentLayout(dc);
    View.onUpdate(dc);

    //@TODO: check me!
    AppHelper.drawScreenGuides(dc);
  }

  // Update the view with the current layout
  protected function updateCurrentLayout(dc) {
    if (currentWorkout.isTerminated()) {
      updateLayoutTerminated(dc);
    } else if (currentWorkout.isRunning()) {
      var currentExercise = currentWorkout.getCurrentExercise();
      if (currentExercise.isItRestTime()) {
        updateLayoutResting(dc);
      } else {
        updateLayoutWorking(dc);
      }
    } else if (currentWorkout.isInRepetitionPause()) {
      updateLayoutRepetitionPause(dc);
    } else {
      Sys.println("Invalid workout state: " + currentWorkout.getState());
    }
  }

  protected function updateLayoutResting(dc) {
    if (currentLayout != LAYOUT_REST) {
      //Sys.println("Layout changed to: RST");
      currentLayout = LAYOUT_REST;
      setLayout(Rez.Layouts.LayoutDoWorkoutRest(dc));

      //Layout elements
      labelHeartRateValue = View.findDrawableById("labelHeartRateValue");
      labelReps = View.findDrawableById("labelReps");
      labelExcs = View.findDrawableById("labelExcs");
      labelExerciseName = View.findDrawableById("labelExerciseName");
      labelTimeRemaining = View.findDrawableById("labelTimeRemaining");
    }

    var txt;
    var currentExercise = currentWorkout.getCurrentExercise();

    // HR
    txt = currentWorkout.getCurrentHeartRate().toString();
    labelHeartRateValue.setText(txt);

    // REPS (R: 1/3)
    txt = Lang.format(str_rep_of_reps, [currentWorkout.getTimesRepeated(), currentWorkout.getNumberOfRepetitions()]);
    labelReps.setText(txt);

    // EXERCISES (E: 4/12)
    txt = Lang.format(str_exc_of_excs, [currentExercise.getExerciseIndex(), currentWorkout.getExerciseCount()]);
    labelExcs.setText(txt);

    // NEXT EXERCISE
    txt = currentExercise.getTitle();
    labelExerciseName.setText(txt);

    // REMAINING TIME
    txt = currentExercise.getRestRemainingSeconds().toString();
    labelTimeRemaining.setText(txt);
  }

  protected function updateLayoutWorking(dc) {
    if (currentLayout != LAYOUT_WORK) {
      //Sys.println("Layout changed to: WRK");
      currentLayout = LAYOUT_WORK;
      setLayout(Rez.Layouts.LayoutDoWorkoutWork(dc));

      //Layout elements
      labelHeartRateValue = View.findDrawableById("labelHeartRateValue");
      labelExerciseName = View.findDrawableById("labelExerciseName");
      labelTimeRemaining = View.findDrawableById("labelTimeRemaining");
    }

    var txt;
    var currentExercise = currentWorkout.getCurrentExercise();

    // HR
    txt = currentWorkout.getCurrentHeartRate().toString();
    labelHeartRateValue.setText(txt);

    // NEXT EXERCISE
    txt = currentExercise.getTitle();
    labelExerciseName.setText(txt);

    // REMAINING TIME
    txt = currentExercise.getExerciseRemainingSeconds().toString();
    labelTimeRemaining.setText(txt);
  }

  protected function updateLayoutRepetitionPause(dc) {
    //LAYOUT_PAUSE
    if (currentLayout != LAYOUT_PAUSE) {
      //Sys.println("Layout changed to: PAUSE");
      currentLayout = LAYOUT_PAUSE;
      setLayout(Rez.Layouts.LayoutDoWorkoutPause(dc));

      //Layout elements
      labelHeartRateValue = View.findDrawableById("labelHeartRateValue");
      labelReps = View.findDrawableById("labelReps");
      labelTimeRemaining = View.findDrawableById("labelTimeRemaining");
    }

    var txt;

    // HR
    txt = currentWorkout.getCurrentHeartRate().toString();
    labelHeartRateValue.setText(txt);

    // REPS (1/3)
    txt = Lang.format("$1$ / $2$", [currentWorkout.getTimesRepeated() + 1, currentWorkout.getNumberOfRepetitions()]);
    labelReps.setText(txt);

    // REMAINING TIME
    txt = currentWorkout.getRepetitionPauseRemainingSeconds().toString();
    labelTimeRemaining.setText(txt);
  }

  protected function updateLayoutTerminated(dc) {
    if (currentLayout != LAYOUT_DONE) {
      //Sys.println("Layout changed to: TRM");
      currentLayout = LAYOUT_DONE;
      setLayout(Rez.Layouts.LayoutDoWorkoutDone(dc));

      //Layout elements
      labelTimeTotal = View.findDrawableById("labelTimeTotal");
    }

    var txt = Lang.format(str_total_time, [currentWorkout.getElapsedSeconds(true)]);
    labelTimeTotal.setText(txt);
  }
}
