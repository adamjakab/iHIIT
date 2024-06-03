using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class doWorkoutView extends Ui.View {
  const LAYOUT_NONE = 0;
  const LAYOUT_REST = 1;
  const LAYOUT_WORK = 2;
  const LAYOUT_DONE = 3;

  private var app;
  private var currentWorkout;
  private var currentLayout;

  // Strings
  private var str_total_time;

  // Layout elements
  private var labelHeartRateValue;
  private var labelExerciseName;
  private var labelTimeRemaining;
  private var labelTimeTotal;

  public function initialize() {
    View.initialize();
    app = App.getApp();
    currentLayout = LAYOUT_NONE;

    // Strings
    str_total_time = Ui.loadResource(Rez.Strings.do_workout_done_total_time);

    Sys.println("DO-WORKOUT-VIEW - INIT");
  }

  //public function onLayout(dc) {}

  // Update the view - update is requested (Ui.requestUpdate()) by the workout model
  public function onUpdate(dc) {
    currentWorkout = app.getController().getCurrentWorkout();
    updateCurrentLayout(dc);
    View.onUpdate(dc);
    //ApeTools.AppHelper.drawScreenGuides(dc);
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
    } else {
      Sys.println("Invalid workout state: " + currentWorkout.getState());
    }
  }

  protected function updateLayoutResting(dc) {
    if (currentLayout != LAYOUT_REST) {
      Sys.println("Layout changed to: RST");
      currentLayout = LAYOUT_REST;
      setLayout(Rez.Layouts.LayoutDoWorkoutRest(dc));

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
    txt = currentExercise.getRestRemainingSeconds().toString();
    labelTimeRemaining.setText(txt);
  }

  protected function updateLayoutWorking(dc) {
    if (currentLayout != LAYOUT_WORK) {
      Sys.println("Layout changed to: WRK");
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

  protected function updateLayoutTerminated(dc) {
    if (currentLayout != LAYOUT_DONE) {
      Sys.println("Layout changed to: TRM");
      currentLayout = LAYOUT_DONE;
      setLayout(Rez.Layouts.LayoutDoWorkoutDone(dc));

      //Layout elements
      labelTimeTotal = View.findDrawableById("labelTimeTotal");
    }

    var txt = Lang.format(str_total_time, [
      currentWorkout.getElapsedSeconds(true),
    ]);
    labelTimeTotal.setText(txt);
  }
}
