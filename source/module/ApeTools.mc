using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;

module ApeTools
{
	//---------------------------------------------------------------------------------------APPLICATION HELPER
	module AppHelper
	{
		var discard_options = {
			0 => Ui.loadResource(Rez.Strings.finish_workout_prompt_resume),
			1 => Ui.loadResource(Rez.Strings.finish_workout_prompt_save_and_exit),
			2 => Ui.loadResource(Rez.Strings.finish_workout_prompt_discard_and_exit),
		};
		
		public function getDiscardOptions(is_workout_terminated)
		{
			var options = {};
			var val;
			var i = 0;
			var max = discard_options.size();
			
			//duplicate
			for (i=0; i < max; i++)
			{
				options.put(i,discard_options.get(i));
			}
			
			if(is_workout_terminated)
			{
				options.remove(0);
			}
			
			if(!is_workout_terminated)
			{
				options.remove(1);
			}
			
		
			return options;
		}
		
		
		
	}
	
	//---------------------------------------------------------------------------------------WORKOUT HELPER
	module WorkoutHelper
	{
		// DO NOT USE THIS
		public function getWorkoutCount()
	    {
	    	var cnt = 0;
	    	
	    	while(getPropertyForWorkout((cnt+1), "title", false) != false)
	    	{
	    		cnt++;
	    	}
			
			return cnt;
	    }
	    
	    // Checks: title, enabled, at least one exercise
	    public function isSelectableWorkout(workout_number)
	    {
	    	var answer = false;
	    	if(getPropertyForWorkout(workout_number, "title", false) != false)
	    	{
	    		if(getPropertyForWorkout(workout_number, "enabled", false) == true)
		    	{
		    		if(ExerciseHelper.getExerciseCount(workout_number) > 0)
			    	{
			    		answer = true;
			    	}
		    	}
	    	}
	    	
	    	return answer;
	    }
	    
	    public function getPropertyForWorkout(workout_number, attribute_name, default_value)
		{
			var property_id = Lang.format("workout_$1$_$2$", [workout_number, attribute_name]);			
		    return PropertyReader.getProperty(property_id, default_value);
		}
	}
	
	//---------------------------------------------------------------------------------------EXERCISE HELPER
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
	
	//---------------------------------------------------------------------------------------PROPERTY HELPER
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