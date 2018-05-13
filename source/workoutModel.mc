using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;
using Toybox.Math as Math;
using Toybox.ActivityRecording as ActivityRecording; //use to log activity
using Toybox.WatchUi as Ui;

/**
 * workoutModel
 * @todo: split into workout and exercise models
 */
class workoutModel
{
	private var session;
	private var session_started = false;
	
	private var max_workout;
	private var selected_workout;
	
	private var current_exercise;
	private var max_exercise;
	
	private var workout_timer;
	private var exercise_timer;
	
	private var workout_elapsed_seconds;
	private var exercise_elapsed_seconds;
	
	private var exercise_duration_seconds;
	private var rest_duration_seconds;
	
	
	// Initialize
    function initialize() {
    	selected_workout = 1;
    	current_exercise = 0;
    	setMaxWorkout();
    	setMaxExercise();
    	
    	workout_elapsed_seconds = 0;
    	
    	workout_timer = new Timer.Timer();
    	exercise_timer = new Timer.Timer();
    	
    	createNewSession();
    }
    
    
    function getCurrentExcerciseName()
    {
    	var exercise_number = isItRestTime() ? current_exercise + 1 : current_exercise;
	    var exercise_name = getPropertyForWorkoutExcercise(selected_workout, exercise_number, "title", false);
	    if (exercise_name == false)
	    {
	    	exercise_name = "END OF WORKOUT";
	    }
	    
	    return exercise_name;
    }
    
    function getCurrentWorkoutName()
    {
	    return getPropertyForWorkout(selected_workout, "title", false);
    }
    
    function getWorkoutElapsedSeconds(format)
    {
    	var answer = workout_elapsed_seconds;
    	if(format == true) {
    		var min = Math.floor(workout_elapsed_seconds / 60);
    		var sec = workout_elapsed_seconds - (60*min);
			answer = Lang.format("$1$:$2$", [min, sec]);  	
    	}
    	return answer;
    }
    
    
    
    
    function workoutTimerCallback() 
	{
	 	workout_elapsed_seconds++;		
	 	Ui.requestUpdate();
 	}
    
    
    function exerciseTimerCallback() 
	{
	 	exercise_elapsed_seconds++;
	 	
	 	if(isExerciseTimeFinished())
	 	{
	 		nextExercise();
	 		Ui.requestUpdate();
	 	}
 	}
 	
 	protected function nextExercise()
 	{
 		current_exercise++;
 		if(current_exercise <= max_exercise)
 		{
 			exercise_elapsed_seconds = 0;
 		} else
 		{
 			App.getApp().getController().stop();
 		} 		
 	} 
 	
 	function isItRestTime()
 	{
 		return exercise_elapsed_seconds > exercise_duration_seconds;
 	}
 	
 	function isExerciseTimeFinished()
 	{
 		return exercise_elapsed_seconds > exercise_duration_seconds + rest_duration_seconds;
 	}
 	
 	function getRestElapsedSeconds()
 	{
 		return isItRestTime() ? exercise_elapsed_seconds - exercise_duration_seconds : 0;
 	}
 	
 	function getRestRemainingSeconds()
 	{
 		return rest_duration_seconds - getRestElapsedSeconds();
 	}
 	
 	function getExerciseElapsedSeconds()
 	{
 		return isItRestTime() ? exercise_duration_seconds : exercise_elapsed_seconds;
 	}
 	
 	function getExerciseRemainingSeconds()
 	{
 		return exercise_duration_seconds - getExerciseElapsedSeconds();
 	}
 	
    protected function setMaxExercise()
    {
    	max_exercise = 0;
    	var i = 1;
    	while(getPropertyForWorkoutExcercise(selected_workout, i, "title", false) != false)
    	{
    		max_exercise = i;
    		i++;
    	}
    	Sys.println("MAXEXERCISE("+selected_workout+") set to: " + max_exercise);
    }
    
    function getNumberOfExercises()
    {
    	return max_exercise;
    }
    
    function isWorkoutFinished()
    {
    	return current_exercise > max_exercise;
    }
    
    /*
     * Start workout recording
     */
    function startRecording()
    {
    	if(!isRecording())
    	{
    		session.start();
    		if(!isSessionStarted())
    		{
    			session_started = true;
    		}
    		workout_timer.start( method(:workoutTimerCallback), 1000, true );
    		exercise_timer.start( method(:exerciseTimerCallback), 1000, true );
    		Sys.println("MODEL - REC");
    	}
    }
    
    /*
     * Stop workout recording
     */
    function stopRecording()
    {
    	if(isRecording())
    	{
    		session.stop();	
    		workout_timer.stop();
    		exercise_timer.stop();	
       		Sys.println("MODEL - STOP");
       	}
    }
    
    /*
     * Discard recording
     */
    function discardRecording()
    {
    	if(session instanceof ActivityRecording.Session)
		{
			if(session.isRecording())
			{
				session.stop();
			}
			session_started = false;
			session.discard();
			session = null;
			Sys.println("MODEL - DISCARD");
		}
    }
    
    /*
     * Save recording
     */
    function saveRecording()
    {
    	if(session instanceof ActivityRecording.Session)
		{
			if(session.isRecording())
			{
				session.stop();
			}
			session_started = false;
			session.save();
			session = null;
			Sys.println("MODEL - SAVED");
		}
    }
    
    function isRecording()
    {
    	return session.isRecording();
    }
    
    function isSessionStarted()
    {
    	return session_started;
    }
    
    /*
     * Create a new recording session - discarding a previous one if necessary
     */
    function createNewSession()
    {
		discardRecording();
		
		setMaxExercise();
		exercise_duration_seconds = getPropertyForWorkout(selected_workout, "exercise_duration", 40);
    	rest_duration_seconds = getPropertyForWorkout(selected_workout, "rest_duration", 20);
    	exercise_elapsed_seconds = exercise_duration_seconds + 1;
    	
    	//Sys.println("eDUR: " + exercise_duration_seconds);
    	//Sys.println("rDUR: " + rest_duration_seconds);
		
		var session_name = getCurrentWorkoutName();
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
    
    
    
    function getSelectedWorkout() {
    	return selected_workout;
    }
    
    function setNextWorkout() {
    	selected_workout++;
    	if(selected_workout > max_workout)
    	{
    		selected_workout = 1;
    	}
    	createNewSession();
    	
    	return getSelectedWorkout();
    }
    
    function setPreviousWorkout() {
    	selected_workout--;
    	if(selected_workout < 1)
    	{
    		selected_workout = max_workout;
    	}
    	createNewSession();
    	
    	return getSelectedWorkout();
    }
    
    private function setMaxWorkout()
    {
		for (var i=1; i < 99; i++) {
			if(getPropertyForWorkout(i, "title", false) != false) {
				max_workout = i;
			}
		}
    }
    
    
    public function getPropertyForWorkoutExcercise(workout_number, exercise_number, attribute_name, default_value)
    {
		var property_id = Lang.format("workout_$1$_exercise_$2$_$3$", [workout_number, exercise_number, attribute_name]);
	    var property_value = App.getApp().getProperty(property_id);
	    if(property_value == null || (property_value instanceof String && property_value.length() == 0)) {
			property_value = default_value;
		}
	    return property_value;
    }
    
    public function getPropertyForWorkout(workout_number, attribute_name, default_value)
    {
		var property_id = Lang.format("workout_$1$_$2$", [workout_number, attribute_name]);
	    var property_value = App.getApp().getProperty(property_id);
	    if(property_value == null || (property_value instanceof String && property_value.length() == 0)) {
			property_value = default_value;
		}
	    return property_value;
    }
    
}