import Toybox.Lang;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;

/**
 * Model: exercise
 */
class Exercise {
  const DEFAULT_EXERCISE_DURATION = 40;
  const DEFAULT_REST_DURATION = 20;
  const COUNTDOWN_SECONDS = 3;

  private var app_use_sound = true;
  private var app_use_vibration = true;

  private var workout_index;
  private var exercise_index;

  private var title;
  private var exercise_duration;
  private var rest_duration;

  private var exercise_timer;
  private var exercise_elapsed;

  private var is_in_rest_mode = true;

  private var vibeDataStart = [
    new Attention.VibeProfile(75, 1000),
    new Attention.VibeProfile(0, 500),
    new Attention.VibeProfile(75, 1000),
    new Attention.VibeProfile(0, 500),
    new Attention.VibeProfile(100, 1000),
  ];

  private var vibeDataStop = [new Attention.VibeProfile(100, 2000)];

  private var vibeDataCountdown = [new Attention.VibeProfile(100, 500)];

  // Initialize
  // @param WOI - Workout index
  // @param EI -  Exercise index
  function initialize(WOI, EI) {
    self.workout_index = WOI;
    self.exercise_index = EI;

    self.title = ExerciseHelper.getPropertyForWorkoutExcercise(self.workout_index, self.exercise_index, "");
    self.exercise_duration = WorkoutHelper.getPropertyForWorkout(
      self.workout_index,
      "exercise_duration",
      Exercise.DEFAULT_EXERCISE_DURATION
    );
    self.rest_duration = WorkoutHelper.getPropertyForWorkout(
      self.workout_index,
      "rest_duration",
      Exercise.DEFAULT_REST_DURATION
    );

    self.app_use_sound = PropertyHelper.getProperty("app_use_sound", self.app_use_sound);
    self.app_use_vibration = PropertyHelper.getProperty("app_use_vibration", self.app_use_vibration);

    self.exercise_timer = new Timer.Timer();
    self.exercise_elapsed = 0;

    Sys.println("EXERCISE created[" + EI + "]: " + self.title);
  }

  function start() {
    Sys.println("EXERCISE - START");
    self.exercise_timer.start(method(:exerciseTimerCallback), 1000, true);
    alert("start");
  }

  function stop() {
    Sys.println("EXERCISE - STOP");
    if (self.exercise_timer instanceof Timer.Timer) {
      self.exercise_timer.stop();
    }
    alert("stop");
  }

  function exerciseTimerCallback() {
    self.exercise_elapsed++;

    //alert when changing from rest to exercise mode
    if (self.is_in_rest_mode != isItRestTime()) {
      alert("work");
    }
    self.is_in_rest_mode = isItRestTime();

    Ui.requestUpdate();
    countdownBeeps();

    if (isExerciseTimeFinished()) {
      self.exercise_timer.stop();
      self.exercise_timer = null;
      App.getApp().getController().getCurrentWorkout().setNextExercise(true);
    }
  }

  private function countdownBeeps() {
    var time_to_phase_end = 0;
    if (self.is_in_rest_mode) {
      time_to_phase_end = self.getRestRemainingSeconds();
    } else {
      time_to_phase_end = self.getExerciseRemainingSeconds();
    }

    if (time_to_phase_end > self.COUNTDOWN_SECONDS || time_to_phase_end == 0) {
      return;
    }
    //Sys.println("COUNTDOWN: " + time_to_phase_end);

    if (self.app_use_sound && Attention has :playTone) {
      Attention.playTone(Attention.TONE_LOUD_BEEP);
    }

    if (self.app_use_vibration && Attention has :vibrate) {
      Attention.vibrate(vibeDataCountdown);
    }
  }

  private function alert(mode) {
    var tone;
    var vibeData;

    if (self.app_use_sound && Attention has :playTone) {
      if (mode == "stop") {
        tone = Attention.TONE_STOP;
      } else {
        tone = Attention.TONE_START;
      }
      Attention.playTone(tone);
    }

    if (self.app_use_vibration && Attention has :vibrate) {
      if (mode == "stop") {
        vibeData = vibeDataStop;
      } else {
        vibeData = vibeDataStart;
      }
      Attention.vibrate(vibeData);
    }
  }

  //--------------------------------------------------------------------------GETTERS
  function isItRestTime() {
    return self.exercise_elapsed < self.rest_duration;
  }

  /*
   * Only used when testing
   */
  (:debug)
  public function setRestTime(restTime as Boolean) {
    if (restTime) {
      self.exercise_elapsed = 5;
      self.rest_duration = 20;
    } else {
      self.exercise_elapsed = 20;
      self.rest_duration = 5;
    }
  }

  function isExerciseTimeFinished() {
    return self.exercise_elapsed >= self.exercise_duration + self.rest_duration;
  }

  function getRestElapsedSeconds() {
    return isItRestTime() ? self.exercise_elapsed : self.rest_duration;
  }

  function getRestRemainingSeconds() {
    return self.rest_duration - getRestElapsedSeconds();
  }

  function getExerciseElapsedSeconds() {
    return isItRestTime() ? 0 : self.exercise_elapsed - self.rest_duration;
  }

  function getExerciseRemainingSeconds() {
    return self.exercise_duration - getExerciseElapsedSeconds();
  }

  function getWorkoutIndex() {
    return self.workout_index;
  }

  function getExerciseIndex() {
    return self.exercise_index;
  }

  function getTitle() {
    return self.title;
  }
}
