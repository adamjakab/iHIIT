using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;
using Toybox.Math as Math;
using Toybox.ActivityRecording as ActivityRecording;
using Toybox.Sensor as Sensor;
using Toybox.WatchUi as Ui;

/**
 * Model: workout
 */
class workout
{
	const STATE_NOT_STARTED = 0;
	const STATE_RUNNING = 1;
	const STATE_PAUSED = 2;
	const STATE_TERMINATED = 3;
	
	private var workout_index;
	private var title;
	private var exercise_duration;
	private var rest_duration;
	
	private var state = STATE_NOT_STARTED;

	private var session;
	
	private var workout_timer;
	
	private var workout_elapsed_seconds;
	
	private var currentExercise;
	
	private var exercise_count;
	
	private var currentHR = 0;
	
	
	// Initialize
	// @param WOI - Workout index
    function initialize(WOI)
    {
    	self.workout_index = WOI;
    	self.title = ApeTools.WorkoutHelper.getPropertyForWorkout(self.workout_index, "title", "");
    	self.exercise_duration = ApeTools.WorkoutHelper.getPropertyForWorkout(self.workout_index, "exercise_duration", exercise.DEFAULT_EXERCISE_DURATION);
    	self.rest_duration = ApeTools.WorkoutHelper.getPropertyForWorkout(self.workout_index, "rest_duration", exercise.DEFAULT_REST_DURATION);
    	
    	self.exercise_count = ApeTools.ExerciseHelper.getExerciseCount(self.workout_index);
    	self.workout_elapsed_seconds = 0;
    	
    	//enable heartrate sensor
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
        Sensor.enableSensorEvents( method(:heartrateSensorCallback) );
    }
    
    // 
	function heartrateSensorCallback(info)
	{
		currentHR = 0;
        if( info.heartRate != null )
        {
            currentHR = info.heartRate.toNumber();
        }
                
        //Ui.requestUpdate();
	}
    
    function workoutTimerCallback() 
	{
	 	workout_elapsed_seconds++;		
	 	Ui.requestUpdate();
 	}
    
    
    public function setNextExercise(autostart)
    {
    	if(self.currentExercise instanceof exercise && !self.currentExercise.isExerciseTimeFinished())
    	{
    		Sys.println("WORKOUT - cannot start next exercise - current one is still running");
    		return;
    	}
    	
    	var exercise_index = 1;
    	if(self.currentExercise instanceof exercise)
    	{
    		exercise_index = self.currentExercise.getExerciseIndex() + 1;
    	}
    	
    	if(exercise_index > self.exercise_count)
    	{
    		Sys.println("WORKOUT - LAST EXERCISE REACHED!");
    		stopRecording();
    		self.state = self.STATE_TERMINATED;
    		//do something else...
    	} else {
    		self.currentExercise = new $.exercise(self.workout_index, exercise_index);
    		if(autostart)
    		{
    			self.currentExercise.start();
    		}
    	}
    }
    
    /*
     * Start workout recording
     */
    function startRecording()
    {
    	if(isNotStarted())
    	{
    		createNewSession();
    		setNextExercise(false);
    		self.workout_timer = new Timer.Timer();
    	}
    	
    	if(!isRunning())
    	{
    		Sys.println("WORKOUT - START");
    		self.session.start();
    		self.currentExercise.start();
    		self.workout_timer.start( method(:workoutTimerCallback), 1000, true );
    		self.state = self.STATE_RUNNING;    		
    		
    	}
    }
    
    /*
     * Stop workout recording
     */
    function stopRecording()
    {
    	if(isRunning())
    	{
    		Sys.println("WORKOUT - STOP");
    		session.stop();	
    		self.currentExercise.stop();
    		self.workout_timer.stop();    		
    		self.state = self.STATE_PAUSED;
       	}
    }
    
    /*
     * Discard recording
     */
    function discardRecording()
    {
    	if(self.session instanceof ActivityRecording.Session)
		{
			if(self.session.isRecording())
			{
				self.session.stop();
			}
			self.session.discard();
			self.session = null;
			self.state = self.STATE_TERMINATED;
			Sys.println("WORKOUT - DISCARD");
		}
    }
    
    /*
     * Save recording
     */
    function saveRecording()
    {
    	if(self.session instanceof ActivityRecording.Session)
		{
			if(self.session.isRecording())
			{
				self.session.stop();
			}
			self.session.save();
			self.session = null;
			self.state = self.STATE_TERMINATED;
			Sys.println("WORKOUT - SAVED");
		}
    }
    
    
    /*
     * Create a new recording session - discarding a previous one if necessary
     */
    function createNewSession()
    {
		if(self.session instanceof ActivityRecording.Session)
		{
			Sys.println("MODEL - CANNOT CREATE NEW SESSION - ONE ALREADY EXISTS!");
			return;
		}		
		
		var session_name = self.title;
		var session_sport = ActivityRecording.SPORT_TRAINING;
		var session_sub_sport = ActivityRecording.SUB_SPORT_CARDIO_TRAINING;
		
		//SUB_SPORT_STRENGTH_TRAINING
		//SUB_SPORT_FLEXIBILITY_TRAINING
	    session = ActivityRecording.createSession({
	    	:name =>		session_name, 
	    	:sport =>		session_sport, 
	    	:subSport =>	session_sub_sport
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
    
    function getExerciseCount() {
    	return self.exercise_count;
    }
    
    function getCurrentExercise() {
    	return self.currentExercise;
    }
    
    function getState() {
    	return self.state;
    }
    
    function getCurrentHeartRate()
    {
    	return currentHR;
    }
    
    function getCalculatedWorkoutDuration() {
    	var total = self.exercise_count * (self.exercise_duration + self.rest_duration);
		return total;
    }
    
     function getFormattedWorkoutDuration() {
    	var total = self.getCalculatedWorkoutDuration();
    	var min = Math.floor(total / 60);
		var sec = total - (60 * min);
		if(sec < 10)
		{
			sec = "0" + sec;
		}
		return Lang.format("$1$:$2$", [min, sec]);
    }
    
    function getElapsedSeconds(format)
    {
    	var answer = workout_elapsed_seconds;
    	if(format == true) {
    		var min = Math.floor(workout_elapsed_seconds / 60);
    		var sec = workout_elapsed_seconds - (60*min);
			answer = Lang.format("$1$:$2$", [min, sec]);
    	}
    	return answer;
    }
    
    public function isNotStarted()
    {
    	return self.state == STATE_NOT_STARTED;
    }
    
    public function isRunning()
    {
    	return self.state == STATE_RUNNING;
    }
    
    public function isPaused()
    {
    	return self.state == STATE_PAUSED;
    }
    
    public function isTerminated()
    {
    	return self.state == STATE_TERMINATED;
    }
}