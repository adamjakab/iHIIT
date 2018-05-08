using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class finishWorkoutView extends Ui.View {
	
	//var select_workout_prompt;
	
    function initialize() {
    	View.initialize();    
    	  	
    	//select_workout_prompt = Ui.loadResource(Rez.Strings.select_workout_prompt);
    	    
        Sys.println("finishWorkoutView");
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
        var txt;
        
        var app = App.getApp();
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        //** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear(); 
        
        txt = "workout finish menu...";
        dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/2, Gfx.FONT_MEDIUM, txt, Gfx.TEXT_JUSTIFY_CENTER);
    }
}

