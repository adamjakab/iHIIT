using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class selectWorkoutView extends Ui.View {

    function initialize() {
    	View.initialize();        
        Sys.println("WSV - INIT");
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
        
        var app = App.getApp();
        var m = app.model;
        var WO = m.getSelectedWorkout();
        
        var title_key = "workout_" + WO + "_title";
        var workout_title = app.getProperty(title_key);
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        //** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear(); 
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        var t = "Select your workout";
        dc.drawText(width/2, height/3, Gfx.FONT_TINY, t, Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/2, Gfx.FONT_MEDIUM, workout_title, Gfx.TEXT_JUSTIFY_CENTER);
    }
}
