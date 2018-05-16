using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;
using Toybox.Math as Math;
using Toybox.WatchUi as Ui;

/**
 * Model: exercise
 */
class exercise
{
	private var current_exercise;
	private var max_exercise;
	
	private var exercise_timer;
	
	private var exercise_elapsed_seconds;
	
	private var exercise_duration_seconds;
	private var rest_duration_seconds;
	
	
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
 	
    
    
    function getNumberOfExercises()
    {
    	return max_exercise;
    }
    

    
    
}