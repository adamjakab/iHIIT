using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

module ApeTools
{
	module WorkoutHelper
	{
		function getWorkoutCount()
	    {
	    	var cnt = 0;
	    	
	    	while(getPropertyForWorkout((cnt+1), "title", false) != false)
	    	{
	    		cnt++;
	    	}
			
			return cnt;
	    }
	    
	    function getPropertyForWorkout(workout_number, attribute_name, default_value)
		{
			var property_id = Lang.format("workout_$1$_$2$", [workout_number, attribute_name]);			
		    return PropertyReader.getProperty(property_id, default_value);
		}
	}
	
	module ExerciseHelper
	{
		function getExerciseCount(WOI)
	    {
	    	var cnt = 0;
	    	
	    	while(getPropertyForWorkoutExcercise(WOI, (cnt+1), "title", false) != false)
	    	{
	    		cnt++;
	    	}
	    	
	    	return cnt;
	    }
	
		function getPropertyForWorkoutExcercise(workout_number, exercise_number, attribute_name, default_value)
	    {
			var property_id = Lang.format("workout_$1$_exercise_$2$_$3$", [workout_number, exercise_number, attribute_name]);
		    return PropertyReader.getProperty(property_id, default_value);
	    }
	}
	
	module PropertyReader
	{
		
		function getProperty(property_id, default_value)
		{
			var property_value = App.getApp().getProperty(property_id);
			
			if(property_value == null || (property_value instanceof Lang.String && property_value.length() == 0))
			{
				property_value = default_value;
			}
			
			//Sys.println("PID: " + property_id + " > " + property_value);
			return property_value;
		}
	}

	
}