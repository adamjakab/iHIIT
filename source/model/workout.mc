using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;
using Toybox.ActivityRecording as ActivityRecording;
using Toybox.Sensor as Sensor;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;

/**
 * Model: workout
 */
class workout {
  const STATE_NOT_STARTED = 0;
  const STATE_RUNNING = 1;
  const STATE_PAUSED = 2; //User paused the execution manually
  const STATE_TERMINATED = 3; //All reps/exercises are finished - waiting to be saved/discarded
  const STATE_SAVED = 4; //Save completed - Workout can be disposed
  const STATE_IN_REPETITION_PAUSE = 5; // In pause between two repetitions

  private var workout_index;

  private var title;
  private var exercise_duration;
  private var rest_duration;
  private var repetitions;
  private var repetition_pause;

  private var state;

  private var session;

  private var workout_timer;

  private var times_repeated;

  private var workout_elapsed_seconds;

  private var currentExercise;

  private var exercise_count;

  private var currentHR = 0;

  // Initialize
  // @param WOI - Workout index
  function initialize(WOI) {
    self.workout_index = WOI;
    self.title = ApeTools.WorkoutHelper.getPropertyForWorkout(
      self.workout_index,
      "title",
      ""
    );

    // These are in exercise.DEFAULT_EXERCISE_DURATION / exercise.DEFAULT_REST_DURATION but need instance to access them (solve me pls)
    var _def_ex_dur = 40;
    var _def_ex_rst = 20;
    self.exercise_duration = ApeTools.WorkoutHelper.getPropertyForWorkout(
      self.workout_index,
      "exercise_duration",
      _def_ex_dur
    );
    self.rest_duration = ApeTools.WorkoutHelper.getPropertyForWorkout(
      self.workout_index,
      "rest_duration",
      _def_ex_rst
    );

    self.state = STATE_NOT_STARTED;
    self.exercise_count = ApeTools.ExerciseHelper.getExerciseCount(
      self.workout_index
    );
    self.times_repeated = 1;
    self.workout_elapsed_seconds = 0;

    //enable heartrate sensor
    Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
    Sensor.enableSensorEvents(method(:heartrateSensorCallback));
  }

  //
  function heartrateSensorCallback(info as $.Toybox.Sensor.Info) as Void {
    currentHR = 0;
    if (info.heartRate != null) {
      currentHR = info.heartRate.toNumber();
    }
    //Ui.requestUpdate();
  }

  function workoutTimerCallback() {
    self.workout_elapsed_seconds++;
    self.checkRepetitionPause();
    Ui.requestUpdate();
  }

  public function setNextExercise(autostart) {
    if (
      self.currentExercise instanceof exercise &&
      !self.currentExercise.isExerciseTimeFinished()
    ) {
      Sys.println(
        "WORKOUT - cannot start next exercise - current one is still running"
      );
      return;
    }

    var next_exercise_index = 1;
    if (self.currentExercise instanceof exercise) {
      next_exercise_index = self.currentExercise.getExerciseIndex() + 1;
    }

    if (next_exercise_index <= self.exercise_count) {
      self.currentExercise = new $.exercise(
        self.workout_index,
        next_exercise_index
      );
      if (autostart) {
        self.currentExercise.start();
      }
    } else {
      self.repetitionFinished();
    }
  }

  protected function repetitionFinished() {
    Sys.println(
      Lang.format("WORKOUT - All exercises finished in repetition: $1$/$2$!", [
        self.times_repeated,
        self.repetitions,
      ])
    );

    if (Attention has :playTone) {
      Attention.playTone(Attention.TONE_INTERVAL_ALERT);
    }

    if (self.times_repeated >= self.repetitions) {
      Sys.println("WORKOUT - LAST REPETITION REACHED - STOPPING SESSION!");
      stopRecording();
      self.state = STATE_TERMINATED;
      Ui.requestUpdate();
    } else {
      Sys.println("WORKOUT - Pausing before new repetition");
      self.currentExercise = null;
      self.state = STATE_IN_REPETITION_PAUSE;
      Ui.requestUpdate();
    }
  }

  protected function checkRepetitionPause() {
    if (!self.isInRepetitionPause()) {
      return;
    }

    if (self.getRepetitionPauseRemainingSeconds() > 0) {
      return;
    }

    self.times_repeated++;
    Sys.println("WORKOUT - Starting new repetition: " + self.times_repeated);
    self.currentExercise = new $.exercise(self.workout_index, 1);
    self.currentExercise.start();
    self.state = STATE_RUNNING;
  }

  /*
   * Start workout recording
   */
  function startRecording() {
    if (isNotStarted()) {
      createNewSession();
      setNextExercise(false);
      self.workout_timer = new Timer.Timer();
    }

    if (!isRunning()) {
      Sys.println("WORKOUT - START");
      self.session.start();
      self.currentExercise.start();
      self.workout_timer.start(method(:workoutTimerCallback), 1000, true);
      self.state = STATE_RUNNING;
    }
  }

  /*
   * Stop workout recording
   */
  function stopRecording() {
    if (isRunning()) {
      Sys.println("WORKOUT - STOP");
      session.stop();
      self.currentExercise.stop();
      self.workout_timer.stop();
      self.state = STATE_PAUSED;
    }
  }

  /*
   * Discard recording
   */
  function discardRecording() {
    if (self.session instanceof ActivityRecording.Session) {
      if (self.session.isRecording()) {
        self.session.stop();
      }
      self.session.discard();
      self.session = null;
      self.state = STATE_TERMINATED;
      Sys.println("WORKOUT - DISCARD");
    }
  }

  /*
   * Save recording
   */
  function saveRecording() {
    if (self.session instanceof ActivityRecording.Session) {
      if (self.session.isRecording()) {
        self.session.stop();
      }
      self.state = STATE_TERMINATED;
      Ui.requestUpdate();
      self.session.save();
      self.session = null;
      Sys.println("WORKOUT - SAVED");
      self.state = STATE_SAVED;
      Ui.requestUpdate();
    }
  }

  /*
   * Create a new recording session - discarding a previous one if necessary
   */
  function createNewSession() {
    if (self.session instanceof ActivityRecording.Session) {
      Sys.println("MODEL - CANNOT CREATE NEW SESSION - ONE ALREADY EXISTS!");
      return;
    }

    var session_name = self.title;
    var session_sport = ActivityRecording.SPORT_TRAINING;
    var session_sub_sport = ActivityRecording.SUB_SPORT_CARDIO_TRAINING;

    //SUB_SPORT_STRENGTH_TRAINING
    //SUB_SPORT_FLEXIBILITY_TRAINING
    session = ActivityRecording.createSession({
      :name => session_name,
      :sport => session_sport,
      :subSport => session_sub_sport,
    });
  }

  //---------------------------------------------------------------------GETTERS
  function getWorkoutIndex() {
    return self.workout_index;
  }

  function getTitle() {
    return self.title;
  }

  function getExerciseDuration() {
    return self.exercise_duration;
  }

  function getRestDuration() {
    return self.rest_duration;
  }

  function getNumberOfRepetitions() {
    return self.repetitions;
  }

  function getTimesRepeated() {
    return self.times_repeated;
  }

  function getRepetitionPause() {
    return self.repetition_pause;
  }

  function getExerciseCount() {
    return self.exercise_count;
  }

  function getCurrentExercise() {
    return self.currentExercise;
  }

  function getState() {
    return self.state;
  }

  function getCurrentHeartRate() {
    return currentHR;
  }

  function getCalculatedWorkoutDuration() {
    // Last repetition_pause is removed because it will not be used at the end of the workout
    return (
      self.repetitions *
        (self.getCalculatedRepetitionDuration() + self.repetition_pause) -
      self.repetition_pause
    );
  }

  function getFormattedWorkoutDuration() {
    var total = self.getCalculatedWorkoutDuration();
    return ApeTools.AppHelper.getFormattedTime(total);
  }

  function getCalculatedRepetitionDuration() {
    return self.exercise_count * (self.exercise_duration + self.rest_duration);
  }

  function getRepetitionPauseRemainingSeconds() {
    var time_left = 0;

    if (self.isInRepetitionPause()) {
      var completed_rep_time =
        self.times_repeated * self.getCalculatedRepetitionDuration() +
        (self.times_repeated - 1) * self.repetition_pause;
      var overtime = self.workout_elapsed_seconds - completed_rep_time;
      time_left = self.repetition_pause - overtime;
      //Sys.println(Lang.format("REP[$1$]-PAUSE: CRT: $2$ | OVR: $3$ | TIME LEFT: $4$", [self.times_repeated, completed_rep_time, overtime, time_left]));
    }

    return time_left;
  }

  function getElapsedSeconds(format) {
    var answer = self.workout_elapsed_seconds;
    if (format == true) {
      answer = ApeTools.AppHelper.getFormattedTime(answer);
    }
    return answer;
  }

  public function isNotStarted() {
    return self.state == STATE_NOT_STARTED;
  }

  public function isRunning() {
    return self.state == STATE_RUNNING;
  }

  public function isPaused() {
    return self.state == STATE_PAUSED;
  }

  public function isTerminated() {
    return self.state == STATE_TERMINATED;
  }

  public function isSaved() {
    return self.state == STATE_SAVED;
  }

  public function isInRepetitionPause() {
    return self.state == STATE_IN_REPETITION_PAUSE;
  }
}
